import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../core/notifications/inactivity_nudge_service.dart';
import '../../core/notifications/notification_service.dart';
import '../../core/widget/study_widget_service.dart';
import '../local/database.dart';
import '../repositories/reminders_repository.dart';
import '../study_streak.dart';

/// The one place that reacts to "you studied" (and to app startup): it
/// recomputes your streak, refreshes the home-screen widget, rebuilds today's
/// reminders (dropping the ones you no longer need) and restarts the
/// multi-day inactivity ladder from your real last activity.
///
/// Call [recordActivity] right after any save that counts as studying.
class StudyActivityService {
  StudyActivityService(this._db, this._reminders);
  final AppDatabase _db;
  final RemindersRepository _reminders;

  /// Full rebuild of the widget, every reminder and the inactivity ladder.
  /// Run at startup and after settings changes.
  Future<void> refreshAll() async {
    try {
      final streak = await computeStudyStreak(_db);
      await StudyWidgetService.publish(
        streak: streak.current,
        lastStudyDay: streak.lastStudyDay,
      );
      await _reminders.rescheduleAll(streak: streak);
      await InactivityNudgeService.instance
          .scheduleFrom(streak.lastActivityAt ?? DateTime.now());
      NotificationService.instance.lastError = null;
    } catch (e, st) {
      // Runs fire-and-forget at startup, so record the failure where the
      // Settings diagnostics card can show it instead of swallowing it.
      NotificationService.instance.lastError = '$e';
      debugPrint('Study activity refresh failed: $e\n$st');
    }
  }

  /// Call right after saving anything that counts as studying.
  ///
  /// The part that matters immediately — the widget, turning today's
  /// reminders into light ones and dropping today's streak alerts — is done
  /// before this returns, so it's safe to await before closing the screen you
  /// saved from (even if you then swipe the app away, the alerts you no
  /// longer need are already gone). The heavier full rebuild carries on in
  /// the background.
  Future<void> recordActivity() async {
    try {
      final streak = await computeStudyStreak(_db);
      await StudyWidgetService.publish(
        streak: streak.current,
        lastStudyDay: streak.lastStudyDay,
      );
      if (streak.studiedToday) await _reminders.switchTodayToGentle(streak);
    } catch (e, st) {
      NotificationService.instance.lastError = '$e';
      debugPrint('Recording study activity failed: $e\n$st');
    }
    unawaited(refreshAll());
  }
}
