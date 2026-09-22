import 'package:drift/drift.dart';
import 'study_entries_table.dart';

/// A public talk you want to review later and be quizzed on.
class Talks extends Table {
  TextColumn get id => text()(); // uuid
  TextColumn get title => text()();
  TextColumn get speaker => text().nullable()();
  DateTimeColumn get date => dateTime()();
  DateTimeColumn get updatedAt => dateTime().clientDefault(() => DateTime.now())();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// An ordered outline point within a talk, optionally linked to a scripture
/// you've logged in StudyEntries so quizzes can ask "which scripture backed this point?".
class TalkPoints extends Table {
  TextColumn get id => text()(); // uuid
  TextColumn get talkId => text().references(Talks, #id)();
  IntColumn get orderIndex => integer()();
  TextColumn get pointText => text()();
  TextColumn get linkedStudyEntryId =>
      text().nullable().references(StudyEntries, #id)();
  DateTimeColumn get updatedAt => dateTime().clientDefault(() => DateTime.now())();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
