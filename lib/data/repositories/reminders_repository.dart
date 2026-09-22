import 'package:drift/drift.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../core/notifications/notification_copy.dart';
import '../../core/notifications/notification_service.dart';
import '../local/database.dart';
import '../study_streak.dart';

class RemindersRepository {
  RemindersRepository(this._db);
  final AppDatabase _db;

  Stream<List<ReminderSetting>> watchAll() => (_db.select(_db.reminderSettings)
        ..orderBy([(r) => OrderingTerm.asc(r.weekday)]))
      .watch();

  /// Seeds one row per weekday (default: every day, 6:00 PM) on first launch.
  Future<void> seedIfEmpty() async {
    final existing = await _db.select(_db.reminderSettings).get();
    if (existing.isNotEmpty) return;
    await _db.batch((batch) {
      batch.insertAll(_db.reminderSettings, [
        for (var day = 1; day <= 7; day++)
          ReminderSettingsCompanion.insert(weekday: Value(day)),
      ]);
    });
  }

  // How many days ahead reminders are scheduled. Each is a separate,
  // one-off notification so its text can be accurate for that specific day.
  // The app rebuilds all of them every time it opens or you study, so this
  // only needs to outlast a stretch of not opening the app — after which
  // the multi-day inactivity ladder (InactivityNudgeService) takes over.
  // A week is deliberate: the ladder's daily "Your study habit is fading"
  // starts at day 6 of silence, so the evening reminders hand over to it
  // right about here instead of stacking on top of it for another week.
  static const _horizonDays = 7;

  // Per-day slots.
  static const _slotMain = 0;
  static const _slotFollowUpBase = 1; // 1..3
  static const _slotStreakEvening = 4;
  static const _slotStreakFinal = 5;

  static const _followUpMinutes = [60, 120, 180];

  // Ids are tied to the calendar *date*, not to "how many days from when the
  // schedule was built" — otherwise, if the app hadn't run since yesterday,
  // "switch today's reminders" would touch yesterday's slot numbers and leave
  // today's alerts to fire wrongly. The date wraps around a ring far wider
  // than the scheduling horizon, so two live reminders never share an id.
  static const _idBase = 10000;
  static const _dateRing = 60;

  static int _epochDay(DateTime day) =>
      DateTime.utc(day.year, day.month, day.day).millisecondsSinceEpoch ~/
      Duration.millisecondsPerDay;

  static int _idFor(DateTime day, int slot) =>
      _idBase + (_epochDay(day) % _dateRing) * 10 + slot;

  /// Whether [id] belongs to a study reminder — including the ids earlier
  /// builds used (weekly repeats 1-7 and 111-173, then 1000-1139), so
  /// upgrading never leaves an old reminder firing alongside the new ones.
  static bool _isReminderId(int id) =>
      (id >= 1 && id <= 7) ||
      (id >= 111 && id <= 173) ||
      (id >= 1000 && id <= 1139) ||
      (id >= _idBase && id < _idBase + _dateRing * 10);

  /// Rebuilds every reminder from the saved settings and today's progress.
  /// Call at startup and again after any study activity.
  ///
  /// A day you've already studied still gets its reminders, just as light
  /// ones (see [_scheduleDay]); a day switched off gets nothing at all —
  /// no reminder, no follow-ups, no streak alerts.
  Future<void> rescheduleAll({StudyStreak? streak}) async {
    final progress = streak ?? await computeStudyStreak(_db);
    final rows = {
      for (final row in await _db.select(_db.reminderSettings).get()) row.weekday: row,
    };
    final notifications = NotificationService.instance;

    await notifications.cancelPendingWhere(_isReminderId);

    final now = notifications.tzNow();
    final today = DateTime(now.year, now.month, now.day);

    for (var offset = 0; offset < _horizonDays; offset++) {
      final day = DateTime(today.year, today.month, today.day + offset);
      final row = rows[day.weekday];
      if (row == null || !row.enabled) continue;

      await _scheduleDay(
        row: row,
        day: day,
        now: now,
        streakDays: _streakOn(day, progress),
        gentle: offset == 0 && progress.studiedToday,
      );
    }
  }

  /// What your streak will be worth *on [day]* if you haven't studied by
  /// then — so a message is true when it arrives, not just when it's set.
  /// A streak survives through the end of the day after you last studied.
  int _streakOn(DateTime day, StudyStreak progress) {
    final last = progress.lastStudyDay;
    if (last == null) return 0;
    final aliveUntil = DateTime(last.year, last.month, last.day + 1);
    return day.isAfter(aliveUntil) ? 0 : progress.current;
  }

  /// The instant reaction to "you just studied": turns the rest of today's
  /// reminders into light ones and drops today's streak alerts. Cheap on
  /// purpose (a handful of calls) so it finishes before the screen you saved
  /// from closes, even if you then swipe the app away.
  Future<void> switchTodayToGentle(StudyStreak progress) async {
    final notifications = NotificationService.instance;
    final now = notifications.tzNow();
    final today = DateTime(now.year, now.month, now.day);

    await notifications.cancelIds([
      _idFor(today, _slotStreakEvening),
      _idFor(today, _slotStreakFinal),
    ]);

    final row = await (_db.select(_db.reminderSettings)
          ..where((r) => r.weekday.equals(today.weekday)))
        .getSingleOrNull();
    if (row == null || !row.enabled) return;

    await _scheduleDay(
      row: row,
      day: today,
      now: now,
      streakDays: _streakOn(today, progress),
      gentle: true,
    );
  }

  /// Schedules one day's reminders (wording lives in NotificationCopy).
  ///
  /// Normal day (you haven't studied): the reminder at your set time, three
  /// hourly follow-ups that get more insistent, and — only while there's a
  /// streak to lose — two end-of-day alerts.
  ///
  /// [gentle] day (you've already studied): the same reminder and follow-ups
  /// still arrive — same vibration, same screen wake-up — as short messages
  /// that don't claim you haven't studied, and the streak alerts are
  /// dropped altogether.
  Future<void> _scheduleDay({
    required ReminderSetting row,
    required DateTime day,
    required tz.TZDateTime now,
    required int streakDays,
    required bool gentle,
  }) async {
    final notifications = NotificationService.instance;
    final n = streakDays;

    Future<void> put(
      int slot,
      int hour,
      int minute,
      NotificationText text,
      NotificationKind kind,
    ) async {
      final when = tz.TZDateTime(tz.local, day.year, day.month, day.day, hour, minute);
      if (!when.isAfter(now)) return;
      await notifications.scheduleReminderOnce(
        id: _idFor(day, slot),
        when: when,
        title: text.title,
        body: text.body,
        kind: kind,
      );
    }

    final followUpKind = gentle ? NotificationKind.gentle : NotificationKind.urgent;

    await put(
      _slotMain,
      row.hour,
      row.minute,
      gentle ? NotificationCopy.gentleMain : NotificationCopy.main(n),
      gentle ? NotificationKind.gentle : NotificationKind.reminder,
    );

    for (var i = 0; i < _followUpMinutes.length; i++) {
      final total = row.hour * 60 + row.minute + _followUpMinutes[i];
      if (total >= 24 * 60) continue; // would spill past midnight
      await put(
        _slotFollowUpBase + i,
        total ~/ 60,
        total % 60,
        gentle ? NotificationCopy.gentleFollowUp(i) : NotificationCopy.followUp(i, n),
        followUpKind,
      );
    }

    // The real "about to blow it" alerts. Unlike the follow-ups (which trail
    // your reminder time, so an early-morning reminder would put "last call"
    // at 11am), these sit at the end of the day no matter when you set
    // your reminder — only while there's a streak to lose, and never on a
    // day you've already studied.
    if (!gentle && n > 0) {
      await put(_slotStreakEvening, 21, 30, NotificationCopy.streakEvening(n), NotificationKind.urgent);
      await put(_slotStreakFinal, 23, 15, NotificationCopy.streakFinal(n), NotificationKind.urgent);
    }
  }

  Future<void> setEnabled(int weekday, bool enabled) async {
    await (_db.update(_db.reminderSettings)..where((r) => r.weekday.equals(weekday)))
        .write(ReminderSettingsCompanion(enabled: Value(enabled)));
    await rescheduleAll();
  }

  Future<void> setTime(int weekday, int hour, int minute) async {
    await (_db.update(_db.reminderSettings)..where((r) => r.weekday.equals(weekday))).write(
      ReminderSettingsCompanion(hour: Value(hour), minute: Value(minute)),
    );
    await rescheduleAll();
  }
}
