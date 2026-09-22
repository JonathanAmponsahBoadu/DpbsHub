import 'local/database.dart';

/// Where you stand on the daily study habit, derived from real activity
/// (verses logged/edited, notes written, talks and talk points added,
/// quizzes finished, "other study" check-ins) — the single source of truth for the Home streak card,
/// the home-screen widget, the "skip today's reminders if you've already
/// studied" logic, and the inactivity nudge ladder.
class StudyStreak {
  const StudyStreak({
    required this.current,
    required this.studiedToday,
    required this.days,
    this.lastActivityAt,
    this.lastStudyDay,
  });

  /// Consecutive days of study, counting back from today (or from yesterday
  /// if you haven't studied yet today — the streak is still alive until the
  /// day ends).
  final int current;

  final bool studiedToday;

  /// Every local calendar day (midnight) on which there was any activity.
  final Set<DateTime> days;

  /// Exact time of the most recent activity, or null if there's been none.
  final DateTime? lastActivityAt;

  /// Local midnight of the most recent day with any activity.
  final DateTime? lastStudyDay;

  bool studiedOn(DateTime day) => days.contains(DateTime(day.year, day.month, day.day));
}

DateTime _dayOf(DateTime t) {
  final local = t.toLocal();
  return DateTime(local.year, local.month, local.day);
}

DateTime _previousDay(DateTime day) => DateTime(day.year, day.month, day.day - 1);

Future<StudyStreak> computeStudyStreak(AppDatabase db, {DateTime? now}) async {
  final stamps = <DateTime>[];

  final entries = await (db.selectOnly(db.studyEntries)
        ..addColumns([db.studyEntries.createdAt, db.studyEntries.updatedAt])
        ..where(db.studyEntries.isDeleted.equals(false)))
      .get();
  for (final row in entries) {
    stamps.add(row.read(db.studyEntries.createdAt)!);
    stamps.add(row.read(db.studyEntries.updatedAt)!);
  }

  final notes = await (db.selectOnly(db.studyNotes)
        ..addColumns([db.studyNotes.createdAt, db.studyNotes.updatedAt])
        ..where(db.studyNotes.isDeleted.equals(false)))
      .get();
  for (final row in notes) {
    stamps.add(row.read(db.studyNotes.createdAt)!);
    stamps.add(row.read(db.studyNotes.updatedAt)!);
  }

  // Public-talk notes are study too. (A talk's own `date` is when it was
  // given — often in the past — so the row's updatedAt is what counts.)
  final talks = await (db.selectOnly(db.talks)
        ..addColumns([db.talks.updatedAt])
        ..where(db.talks.isDeleted.equals(false)))
      .get();
  for (final row in talks) {
    stamps.add(row.read(db.talks.updatedAt)!);
  }

  final points = await (db.selectOnly(db.talkPoints)
        ..addColumns([db.talkPoints.updatedAt])
        ..where(db.talkPoints.isDeleted.equals(false)))
      .get();
  for (final row in points) {
    stamps.add(row.read(db.talkPoints.updatedAt)!);
  }

  // Manual "I studied" check-ins (JW Broadcasting, restudy, drawing…).
  final logs = await (db.selectOnly(db.studyLogs)
        ..addColumns([db.studyLogs.createdAt])
        ..where(db.studyLogs.isDeleted.equals(false)))
      .get();
  for (final row in logs) {
    stamps.add(row.read(db.studyLogs.createdAt)!);
  }

  // Only quizzes you actually finished count — starting one and bailing
  // out isn't studying.
  final quizzes = await (db.selectOnly(db.quizSessions)
        ..addColumns([db.quizSessions.finishedAt])
        ..where(db.quizSessions.finishedAt.isNotNull()))
      .get();
  for (final row in quizzes) {
    final finished = row.read(db.quizSessions.finishedAt);
    if (finished != null) stamps.add(finished);
  }

  final today = _dayOf(now ?? DateTime.now());
  final days = {for (final s in stamps) _dayOf(s)};
  final studiedToday = days.contains(today);

  var cursor = studiedToday ? today : _previousDay(today);
  var current = 0;
  while (days.contains(cursor)) {
    current++;
    cursor = _previousDay(cursor);
  }

  DateTime? lastActivityAt;
  for (final s in stamps) {
    if (lastActivityAt == null || s.isAfter(lastActivityAt)) lastActivityAt = s;
  }
  DateTime? lastStudyDay;
  for (final d in days) {
    if (lastStudyDay == null || d.isAfter(lastStudyDay)) lastStudyDay = d;
  }

  return StudyStreak(
    current: current,
    studiedToday: studiedToday,
    days: days,
    lastActivityAt: lastActivityAt,
    lastStudyDay: lastStudyDay,
  );
}
