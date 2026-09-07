import 'package:drift/drift.dart';

/// One row per weekday (1=Monday .. 7=Sunday, matching DateTime.weekday) for
/// the daily "study your Bible" reminder — each day independently toggled
/// on/off with its own time, so e.g. Wednesday can be off while every other
/// day fires at a different hour.
class ReminderSettings extends Table {
  IntColumn get weekday => integer()(); // 1-7, DateTime.weekday convention
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
  IntColumn get hour => integer().withDefault(const Constant(18))();
  IntColumn get minute => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {weekday};
}
