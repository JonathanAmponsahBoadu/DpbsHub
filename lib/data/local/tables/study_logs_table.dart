import 'package:drift/drift.dart';

/// A manual "I studied" check-in for study that doesn't leave notes or verses
/// behind — watching JW Broadcasting, restudying, drawing, family worship,
/// and so on. It counts toward your streak exactly like a note does.
class StudyLogs extends Table {
  TextColumn get id => text()(); // uuid

  /// One of the keys in features/study_log/study_log_kinds.dart
  /// ('broadcasting', 'restudy', 'drawing', 'family', 'meeting', 'other').
  TextColumn get kind => text()();

  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
