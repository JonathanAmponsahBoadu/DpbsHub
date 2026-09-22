import 'package:drift/drift.dart';

/// A media file (photo, video, or voice note) attached to a verse entry, a
/// standalone note, or a talk. The file itself lives in app storage under
/// attachments/<id>.<ext> (see AttachmentsRepository) — this row is just the
/// pointer plus metadata, which is all that's small enough to sync.
class Attachments extends Table {
  TextColumn get id => text()(); // uuid

  /// 'studyEntry', 'studyNote', or 'talk' — which table [ownerId] points into.
  TextColumn get ownerType => text()();
  TextColumn get ownerId => text()();

  /// 'image', 'video', or 'audio'.
  TextColumn get kind => text()();

  /// Filename only (relative to the attachments directory), not a full path
  /// — the app's documents directory can move between installs/devices.
  TextColumn get fileName => text()();

  /// Original extension, used to pick a player/viewer without relying on
  /// the filename (e.g. 'jpg', 'mp4', 'm4a').
  TextColumn get extension => text()();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
