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
import 'tables/study_logs_table.dart';
import 'tables/attachments_table.dart';

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
  StudyLogs,
  Attachments,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          // Databases older than v4 were pre-release and held no data worth
          // keeping, so those are simply rebuilt from scratch.
          if (from < 4) {
            for (final table in allTables) {
              await m.deleteTable(table.actualTableName);
            }
            await m.createAll();
            return;
          }

          // From v4 on the database holds real study data: every upgrade
          // below must ADD to it, never drop or recreate existing tables.
          if (from < 5) {
            await m.createTable(studyLogs);
          }
          if (from < 6) {
            await m.createTable(attachments);
          }
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
