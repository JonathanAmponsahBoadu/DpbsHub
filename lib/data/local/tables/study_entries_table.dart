import 'package:drift/drift.dart';
import 'books_table.dart';

/// A scripture range you have personally studied. [verseText] stays null until
/// you type/paste it in yourself — never pre-populated, never scraped.
class StudyEntries extends Table {
  TextColumn get id => text()(); // uuid
  IntColumn get bookId => integer().references(Books, #id)();
  IntColumn get chapter => integer()();
  IntColumn get verseStart => integer()();
  IntColumn get verseEnd => integer()();
  TextColumn get language => text()(); // 'en' | 'tw'
  TextColumn get verseText => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  // Soft-delete flag: cloud sync needs a tombstone to propagate a deletion to
  // your other devices instead of a row just silently reappearing on pull.
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
