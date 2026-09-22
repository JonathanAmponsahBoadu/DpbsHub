import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../../data/study_streak.dart';

/// Your live streak. Re-computed whenever anything that counts as studying
/// changes, so the Home card ticks over the moment you save something.
final studyStreakProvider = StreamProvider<StudyStreak>((ref) {
  final db = ref.watch(databaseProvider);
  return db
      .customSelect(
        'SELECT 1',
        readsFrom: {
          db.studyEntries,
          db.studyNotes,
          db.quizSessions,
          db.talks,
          db.talkPoints,
          db.studyLogs,
        },
      )
      .watch()
      .asyncMap((_) => computeStudyStreak(db));
});

final studiedVersesCountProvider = StreamProvider<int>((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.studyEntries).watch().map((rows) => rows.length);
});

final notesCountProvider = StreamProvider<int>((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.studyNotes).watch().map((rows) => rows.length);
});

final quizzesTakenCountProvider = StreamProvider<int>((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.quizSessions).watch().map(
        (rows) => rows.where((r) => r.finishedAt != null).length,
      );
});
