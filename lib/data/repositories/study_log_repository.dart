import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../local/database.dart';

/// Manual "I studied" check-ins for study that leaves no notes or verses
/// behind (see tables/study_logs_table.dart). They count toward your streak
/// exactly like a saved note does.
class StudyLogRepository {
  StudyLogRepository(this._db);
  final AppDatabase _db;
  static const _uuid = Uuid();

  Future<String> add({required String kind, String? note}) async {
    final id = _uuid.v4();
    final now = DateTime.now();
    await _db.into(_db.studyLogs).insert(StudyLogsCompanion.insert(
          id: id,
          kind: kind,
          note: Value(note),
          createdAt: now,
          updatedAt: now,
        ));
    return id;
  }

  /// Soft-delete (a tombstone) so cloud sync can carry the removal to your
  /// other devices — same convention as every other synced table.
  Future<void> remove(String id) =>
      (_db.update(_db.studyLogs)..where((l) => l.id.equals(id))).write(
        StudyLogsCompanion(
          isDeleted: const Value(true),
          updatedAt: Value(DateTime.now()),
        ),
      );
}
