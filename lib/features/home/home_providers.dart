import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';

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
