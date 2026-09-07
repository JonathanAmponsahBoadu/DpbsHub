import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../local/database.dart';

class BibleRepository {
  BibleRepository(this._db);
  final AppDatabase _db;
  static const _uuid = Uuid();

  Stream<List<Book>> watchBooks() =>
      (_db.select(_db.books)..orderBy([(b) => OrderingTerm.asc(b.id)])).watch();

  Future<Book> bookById(int id) =>
      (_db.select(_db.books)..where((b) => b.id.equals(id))).getSingle();

  /// All study entries you've logged for a given book+chapter, ordered by verse.
  Stream<List<StudyEntry>> watchEntriesForChapter(int bookId, int chapter) {
    final query = _db.select(_db.studyEntries)
      ..where((e) => e.bookId.equals(bookId) & e.chapter.equals(chapter))
      ..orderBy([(e) => OrderingTerm.asc(e.verseStart)]);
    return query.watch();
  }

  /// Which chapters (1..chapterCount) already have at least one saved entry —
  /// used to badge the chapter grid so you can see study progress at a glance.
  Stream<Set<int>> watchStudiedChapters(int bookId) {
    final query = _db.selectOnly(_db.studyEntries, distinct: true)
      ..addColumns([_db.studyEntries.chapter])
      ..where(_db.studyEntries.bookId.equals(bookId));
    return query
        .map((row) => row.read(_db.studyEntries.chapter)!)
        .watch()
        .map((rows) => rows.toSet());
  }

  Future<StudyEntry> addOrUpdateEntry({
    String? id,
    required int bookId,
    required int chapter,
    required int verseStart,
    required int verseEnd,
    required String language,
    String? verseText,
  }) async {
    final now = DateTime.now();
    final entryId = id ?? _uuid.v4();
    final companion = StudyEntriesCompanion(
      id: Value(entryId),
      bookId: Value(bookId),
      chapter: Value(chapter),
      verseStart: Value(verseStart),
      verseEnd: Value(verseEnd),
      language: Value(language),
      verseText: Value(verseText),
      createdAt: id == null ? Value(now) : const Value.absent(),
      updatedAt: Value(now),
    );
    await _db.into(_db.studyEntries).insertOnConflictUpdate(companion);
    return (_db.select(_db.studyEntries)..where((e) => e.id.equals(entryId)))
        .getSingle();
  }

  Future<void> deleteEntry(String id) =>
      (_db.delete(_db.studyEntries)..where((e) => e.id.equals(id))).go();

  /// Every scripture you've logged, across all books — used by the Notes
  /// page to let you attach a note to an existing entry without leaving it.
  Stream<List<StudyEntry>> watchAllEntries() => (_db.select(_db.studyEntries)
        ..orderBy([
          (e) => OrderingTerm.asc(e.bookId),
          (e) => OrderingTerm.asc(e.chapter),
          (e) => OrderingTerm.asc(e.verseStart),
        ]))
      .watch();
}
