import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';

/// Pushes your streak to the Android home-screen widget (the native side is
/// StudyStreakWidgetProvider.kt). Values are stored as strings so the Kotlin
/// side never has to guess whether a number arrived as Int or Long.
///
/// The widget works out the rest by itself from these two values plus the
/// current date — whether you've studied today, whether the streak is at
/// risk, how many hours are left — so it stays accurate at midnight even if
/// the app hasn't been opened.
class StudyWidgetService {
  StudyWidgetService._();

  static const _androidProvider = 'StudyStreakWidgetProvider';

  /// Days since 1970-01-01 for the *local* calendar date of [day] — the same
  /// value the Kotlin side computes for "today", so the two can be compared
  /// directly.
  static int _epochDay(DateTime day) =>
      DateTime.utc(day.year, day.month, day.day).millisecondsSinceEpoch ~/
      Duration.millisecondsPerDay;

  static Future<void> publish({required int streak, required DateTime? lastStudyDay}) async {
    try {
      await HomeWidget.saveWidgetData<String>('streak', '$streak');
      await HomeWidget.saveWidgetData<String>(
        'lastStudyEpochDay',
        lastStudyDay == null ? '' : '${_epochDay(lastStudyDay)}',
      );
      // Real data always wins: any real update ends a preview.
      await HomeWidget.saveWidgetData<String>('previewState', '');
      await HomeWidget.updateWidget(androidName: _androidProvider);
    } catch (e) {
      // The widget is a nicety — never let it break saving a verse.
      debugPrint('Home widget update skipped: $e');
    }
  }

  /// Pins the real home-screen widget to one of its looks — 'studied',
  /// 'atrisk', 'urgent' (the blinking one) or 'idle' — so Settings can show
  /// them on demand. Pass null to go back to live data. A preview also
  /// expires on its own after ten minutes.
  static Future<void> setPreview(String? state) async {
    try {
      await HomeWidget.saveWidgetData<String>('previewState', state ?? '');
      await HomeWidget.saveWidgetData<String>(
        'previewAt',
        state == null ? '' : '${DateTime.now().millisecondsSinceEpoch}',
      );
      await HomeWidget.updateWidget(androidName: _androidProvider);
    } catch (e) {
      debugPrint('Widget preview failed: $e');
    }
  }

  static Future<bool> canPin() async {
    try {
      return await HomeWidget.isRequestPinWidgetSupported() ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Asks the launcher to add the widget to the home screen (shows the
  /// system's own confirmation prompt).
  static Future<void> requestPin() async {
    try {
      await HomeWidget.requestPinWidget(androidName: _androidProvider);
    } catch (e) {
      debugPrint('Pin widget request failed: $e');
    }
  }
}
