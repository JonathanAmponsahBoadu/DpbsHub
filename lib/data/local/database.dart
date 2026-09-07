import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables/books_table.dart';
import 'tables/study_entries_table.dart';
import 'tables/tags_table.dart';
import 'tables/notes_table.dart';
import 'tables/talks_table.dart';
import 'tables/quiz_table.dart';
import 'tables/reminder_settings_table.dart';

part 'database.g.dart';

@DriftDatabase(tables: [
  Books,
  StudyEntries,
  Tags,
  StudyNotes,
  NoteTagLinks,
  Talks,
  TalkPoints,
  QuizSessions,
  QuizAttempts,
  ReminderSettings,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          // Pre-release app, no real user data to preserve yet: simplest
          // correct migration is to rebuild the schema from scratch rather
          // than hand-write incremental ALTER steps for each version bump.
          for (final table in allTables) {
            await m.deleteTable(table.actualTableName);
          }
          await m.createAll();
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'dpbshub.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
