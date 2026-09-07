import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../local/database.dart';

class NoteWithTags {
  NoteWithTags(this.note, this.tags, this.entry);
  final StudyNote note;
  final List<Tag> tags;
  final StudyEntry? entry;
}

class NotesRepository {
  NotesRepository(this._db);
  final AppDatabase _db;
  static const _uuid = Uuid();

  Stream<List<Tag>> watchTags() =>
      (_db.select(_db.tags)..orderBy([(t) => OrderingTerm.asc(t.name)])).watch();

  Future<Tag> createTag(String name, {String colorHex = 'FF6750A4'}) async {
    final tag = TagsCompanion.insert(
      id: _uuid.v4(),
      name: name,
      colorHex: Value(colorHex),
    );
    await _db.into(_db.tags).insert(tag);
    return (_db.select(_db.tags)..where((t) => t.name.equals(name))).getSingle();
  }

  /// All notes, newest first, each resolved with its tags and (if any) the
  /// scripture entry it's attached to. Simple in-memory join — fine at the
  /// data volumes a personal study log accumulates.
  Stream<List<NoteWithTags>> watchAllNotes() async* {
    final notesStream = (_db.select(_db.studyNotes)
          ..orderBy([(n) => OrderingTerm.desc(n.updatedAt)]))
        .watch();
    await for (final notes in notesStream) {
      yield await _resolve(notes);
    }
  }

  Stream<List<NoteWithTags>> watchNotesForEntry(String studyEntryId) async* {
    final notesStream = (_db.select(_db.studyNotes)
          ..where((n) => n.studyEntryId.equals(studyEntryId)))
        .watch();
    await for (final notes in notesStream) {
      yield await _resolve(notes);
    }
  }

  Future<List<NoteWithTags>> _resolve(List<StudyNote> notes) async {
    final result = <NoteWithTags>[];
    for (final note in notes) {
      final tagLinks = await (_db.select(_db.noteTagLinks)
            ..where((l) => l.noteId.equals(note.id)))
          .get();
      final tags = <Tag>[];
      for (final link in tagLinks) {
        tags.add(await (_db.select(_db.tags)..where((t) => t.id.equals(link.tagId)))
            .getSingle());
      }
      StudyEntry? entry;
      if (note.studyEntryId != null) {
        entry = await (_db.select(_db.studyEntries)
              ..where((e) => e.id.equals(note.studyEntryId!)))
            .getSingleOrNull();
      }
      result.add(NoteWithTags(note, tags, entry));
    }
    return result;
  }

  Future<StudyNote> addNote({
    required String noteText,
    required String source, // 'personalStudy' | 'publicTalk'
    String? studyEntryId,
    List<String> tagIds = const [],
  }) async {
    final now = DateTime.now();
    final id = _uuid.v4();
    await _db.into(_db.studyNotes).insert(StudyNotesCompanion.insert(
          id: id,
          noteText: noteText,
          source: source,
          studyEntryId: Value(studyEntryId),
          createdAt: now,
          updatedAt: now,
        ));
    for (final tagId in tagIds) {
      await _db.into(_db.noteTagLinks).insert(
            NoteTagLinksCompanion.insert(noteId: id, tagId: tagId),
            mode: InsertMode.insertOrIgnore,
          );
    }
    return (_db.select(_db.studyNotes)..where((n) => n.id.equals(id))).getSingle();
  }

  /// Updates a note's text, attached scripture, and full tag set (tags are
  /// replaced wholesale — simplest correct way to support adding/removing
  /// several at once from an edit form).
  Future<void> updateNote({
    required String id,
    required String noteText,
    String? studyEntryId,
    List<String> tagIds = const [],
  }) async {
    await (_db.update(_db.studyNotes)..where((n) => n.id.equals(id))).write(
      StudyNotesCompanion(
        noteText: Value(noteText),
        studyEntryId: Value(studyEntryId),
        updatedAt: Value(DateTime.now()),
      ),
    );
    await (_db.delete(_db.noteTagLinks)..where((l) => l.noteId.equals(id))).go();
    for (final tagId in tagIds) {
      await _db.into(_db.noteTagLinks).insert(
            NoteTagLinksCompanion.insert(noteId: id, tagId: tagId),
            mode: InsertMode.insertOrIgnore,
          );
    }
  }

  Future<void> deleteNote(String id) =>
      (_db.delete(_db.studyNotes)..where((n) => n.id.equals(id))).go();
}
