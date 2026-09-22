import 'package:drift/drift.dart';
import 'study_entries_table.dart';
import 'tags_table.dart';

/// A study note. Optionally attached to one StudyEntry (a scripture range) and/or
/// to a Talk (see talks_table.dart) — e.g. "lesson learned" notes from personal
/// study, or a point captured from a public talk.
class StudyNotes extends Table {
  TextColumn get id => text()(); // uuid
  TextColumn get noteText => text()();
  TextColumn get source => text()(); // 'personalStudy' | 'publicTalk'
  TextColumn get studyEntryId =>
      text().nullable().references(StudyEntries, #id)();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Many-to-many join: a note can carry several tags, a tag can label many notes.
class NoteTagLinks extends Table {
  TextColumn get noteId => text().references(StudyNotes, #id)();
  TextColumn get tagId => text().references(Tags, #id)();

  @override
  Set<Column> get primaryKey => {noteId, tagId};
}
