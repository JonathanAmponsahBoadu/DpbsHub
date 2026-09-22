import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../local/database.dart';

/// Owner types an attachment can hang off — kept as plain strings in the
/// database so a new owner kind is just a new constant, no migration.
abstract final class AttachmentOwner {
  static const studyEntry = 'studyEntry';
  static const studyNote = 'studyNote';
  static const talk = 'talk';
}

abstract final class AttachmentKind {
  static const image = 'image';
  static const video = 'video';
  static const audio = 'audio';
}

/// Stores photos, videos and voice notes attached to a verse, a note, or a
/// talk. Files are copied into the app's own documents directory (never
/// referenced by their original picker path, which can vanish or be
/// permission-locked on the next launch) under attachments/, named by the
/// row's own id so a filename collision is impossible.
class AttachmentsRepository {
  AttachmentsRepository(this._db);
  final AppDatabase _db;
  static const _uuid = Uuid();

  Future<Directory> _attachmentsDir() async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docs.path, 'attachments'));
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }

  Future<File> fileFor(Attachment a) async {
    final dir = await _attachmentsDir();
    return File(p.join(dir.path, a.fileName));
  }

  Stream<List<Attachment>> watchFor(String ownerType, String ownerId) {
    return (_db.select(_db.attachments)
          ..where((a) =>
              a.ownerType.equals(ownerType) &
              a.ownerId.equals(ownerId) &
              a.isDeleted.equals(false))
          ..orderBy([(a) => OrderingTerm.asc(a.createdAt)]))
        .watch();
  }

  /// Copies [sourcePath] into app storage and records it against the owner.
  /// [extension] should be lowercase, no leading dot (e.g. 'jpg', 'mp4').
  Future<Attachment> add({
    required String ownerType,
    required String ownerId,
    required String kind,
    required String sourcePath,
    required String extension,
  }) async {
    final id = _uuid.v4();
    final fileName = '$id.$extension';
    final dir = await _attachmentsDir();
    await File(sourcePath).copy(p.join(dir.path, fileName));

    final now = DateTime.now();
    final companion = AttachmentsCompanion.insert(
      id: id,
      ownerType: ownerType,
      ownerId: ownerId,
      kind: kind,
      fileName: fileName,
      extension: extension,
      createdAt: now,
      updatedAt: now,
    );
    await _db.into(_db.attachments).insert(companion);
    return (_db.select(_db.attachments)..where((a) => a.id.equals(id))).getSingle();
  }

  /// Soft-delete the row (so cloud sync carries the removal to other
  /// devices) and remove the local file immediately — no point keeping
  /// media on disk for a row that's tombstoned.
  Future<void> remove(Attachment a) async {
    await (_db.update(_db.attachments)..where((row) => row.id.equals(a.id))).write(
      AttachmentsCompanion(isDeleted: const Value(true), updatedAt: Value(DateTime.now())),
    );
    try {
      final file = await fileFor(a);
      if (await file.exists()) await file.delete();
    } catch (_) {
      // Best-effort — a stale file left behind never breaks the app, it's
      // just orphaned bytes.
    }
  }
}
