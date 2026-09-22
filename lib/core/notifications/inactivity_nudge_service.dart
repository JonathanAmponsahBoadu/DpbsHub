import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

import 'notification_copy.dart';
import 'notification_service.dart';

/// Duolingo-style escalating "come back" reminders for when you go quiet
/// for days. Every time you log study activity the ladder is rebuilt from
/// that moment (see StudyActivityService); if you then stay away,
/// notifications land at midday on day 1, 2, 3 and 5 with increasingly
/// urgent copy, and from day 6 onward it nags daily until you study again.
///
/// This is the *multi-day* half of the "hard to ignore" system. The
/// same-day half — the daily reminder plus its hourly follow-ups — lives in
/// RemindersRepository.
class InactivityNudgeService {
  InactivityNudgeService._();
  static final instance = InactivityNudgeService._();

  static const _prefsKey = 'inactivity_nudges_enabled';
  static const _nudgeHour = 12;

  // Fixed notification ids, separate from the daily-reminder range so the
  // two features never collide when cancelling/rescheduling.
  static const _dayIds = {1: 601, 2: 602, 3: 603, 5: 604};
  static const _repeatingId = 699;

  // Wording lives in NotificationCopy.inactivityRungs / .inactivityDaily.
  // From this day of silence on, the daily nag runs every noon until you study.
  static const _repeatingFromDay = 6;

  Future<bool> isEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_prefsKey) ?? true;
  }

  /// Persists the setting and, when turning it off, cancels everything
  /// pending. Turning it *on* is followed by StudyActivityService.refreshAll(),
  /// which rebuilds the ladder from your real last activity.
  Future<void> setEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKey, enabled);
    if (!enabled) await cancelAll();
  }

  Future<void> cancelAll() async {
    await NotificationService.instance.cancelIds([..._dayIds.values, _repeatingId]);
  }

  /// Rebuilds the whole ladder relative to [lastActivity]. Safe to call on
  /// every app startup: rungs whose day has already passed are skipped
  /// rather than fired all at once, so reopening the app after a long
  /// absence doesn't dump a flood of stale nudges.
  Future<void> scheduleFrom(DateTime lastActivity) async {
    await cancelAll();
    if (!await isEnabled()) return;

    final now = NotificationService.instance.tzNow();

    for (final entry in NotificationCopy.inactivityRungs.entries) {
      final when = _noon(lastActivity, entry.key);
      if (!when.isAfter(now)) continue; // already elapsed — don't backfire
      await NotificationService.instance.scheduleOneShot(
        id: _dayIds[entry.key]!,
        title: entry.value.title,
        body: entry.value.body,
        when: when,
        kind: NotificationKind.nudge,
      );
    }

    // Daily nag from day 6 on: first occurrence is midday on that day, or
    // the next midday if we're already past it.
    var firstRepeat = _noon(lastActivity, _repeatingFromDay);
    if (!firstRepeat.isAfter(now)) {
      firstRepeat = _noon(now, 0);
      if (!firstRepeat.isAfter(now)) firstRepeat = _noon(now, 1);
    }
    await NotificationService.instance.scheduleDailyRepeating(
      id: _repeatingId,
      title: NotificationCopy.inactivityDaily.title,
      body: NotificationCopy.inactivityDaily.body,
      firstOccurrence: firstRepeat,
    );
  }

  tz.TZDateTime _noon(DateTime base, int plusDays) =>
      tz.TZDateTime(tz.local, base.year, base.month, base.day + plusDays, _nudgeHour);
}
