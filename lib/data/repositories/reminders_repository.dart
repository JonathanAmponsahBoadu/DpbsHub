import 'package:drift/drift.dart';

import '../../core/notifications/notification_service.dart';
import '../local/database.dart';

class RemindersRepository {
  RemindersRepository(this._db);
  final AppDatabase _db;

  Stream<List<ReminderSetting>> watchAll() => (_db.select(_db.reminderSettings)
        ..orderBy([(r) => OrderingTerm.asc(r.weekday)]))
      .watch();

  /// Seeds one row per weekday (default: every day, 6:00 PM) on first launch.
  Future<void> seedIfEmpty() async {
    final existing = await _db.select(_db.reminderSettings).get();
    if (existing.isNotEmpty) return;
    await _db.batch((batch) {
      batch.insertAll(_db.reminderSettings, [
        for (var day = 1; day <= 7; day++)
          ReminderSettingsCompanion.insert(weekday: Value(day)),
      ]);
    });
  }

  /// (Re)schedules every enabled day's notification against the current
  /// saved settings — call once at app startup so reminders survive an app
  /// reinstall/update and stay correct if the OS dropped an alarm.
  Future<void> rescheduleAll() async {
    final rows = await _db.select(_db.reminderSettings).get();
    for (final row in rows) {
      if (row.enabled) {
        await NotificationService.instance
            .scheduleWeekly(weekday: row.weekday, hour: row.hour, minute: row.minute);
      } else {
        await NotificationService.instance.cancel(row.weekday);
      }
    }
  }

  Future<void> setEnabled(int weekday, bool enabled) async {
    await (_db.update(_db.reminderSettings)..where((r) => r.weekday.equals(weekday)))
        .write(ReminderSettingsCompanion(enabled: Value(enabled)));
    final row = await (_db.select(_db.reminderSettings)..where((r) => r.weekday.equals(weekday)))
        .getSingle();
    if (enabled) {
      await NotificationService.instance
          .scheduleWeekly(weekday: weekday, hour: row.hour, minute: row.minute);
    } else {
      await NotificationService.instance.cancel(weekday);
    }
  }

  Future<void> setTime(int weekday, int hour, int minute) async {
    await (_db.update(_db.reminderSettings)..where((r) => r.weekday.equals(weekday))).write(
      ReminderSettingsCompanion(hour: Value(hour), minute: Value(minute)),
    );
    final row = await (_db.select(_db.reminderSettings)..where((r) => r.weekday.equals(weekday)))
        .getSingle();
    if (row.enabled) {
      await NotificationService.instance.scheduleWeekly(weekday: weekday, hour: hour, minute: minute);
    }
  }
}
