import 'dart:typed_data';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../theme/app_theme.dart';

/// Every kind of notification DpbsHub sends. The kind alone decides how it
/// looks and behaves — its Android channel (which is what you see in the
/// phone's notification settings), how loud it is, whether it vibrates and
/// whether it may light up a sleeping screen — so a preview in Settings and
/// the real thing can never differ.
enum NotificationKind {
  /// The reminder at your set time.
  reminder,

  /// Same-day follow-ups and end-of-day streak alerts: louder, vibrates.
  urgent,

  /// Softer-worded version on a day you've already studied. Behaves exactly
  /// like [reminder] (vibrates, can wake the screen) — only the wording and
  /// the missing streak alerts set it apart.
  gentle,

  /// Multi-day nudges (1, 2, 3 and 5 days of silence).
  nudge,

  /// The daily "study habit is fading" nag from day 6 of silence.
  nudgeDaily,

  /// The instant "Send test now" button.
  test,
}

/// Wraps flutter_local_notifications for every notification DpbsHub shows:
/// the same-day reminders and their follow-ups, and the escalating
/// inactivity nudges (see inactivity_nudge_service.dart). One shared plugin
/// instance/init so channel setup and permission state stay consistent.
class NotificationService {
  NotificationService._();
  static final instance = NotificationService._();

  static const _askedExactAlarmKey = 'asked_exact_alarm_permission';
  static const _wakeScreenKey = 'wake_screen_for_reminders';

  /// The small monochrome icon in the status bar and notification header
  /// (android/app/src/main/res/drawable/ic_stat_dpbshub.xml — an open book).
  /// Android only draws a notification's small icon as a flat silhouette, so
  /// the full-colour app icon would show up as a blank white square.
  static const smallIcon = 'ic_stat_dpbshub';

  /// Fixed id for the "schedule a test in a minute" diagnostic.
  static const scheduledTestId = 9001;

  /// Ids 9200-9299 are reserved for Settings → "Preview notifications".
  static const _previewIdBase = 9200;

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  /// The last error hit while (re)building the notification schedule, shown
  /// in Settings → diagnostics. Scheduling runs fire-and-forget at startup,
  /// so without this a failure there would be completely invisible.
  String? lastError;

  Future<void> init() async {
    if (_initialized) return;
    tz_data.initializeTimeZones();
    try {
      final localTz = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(localTz.identifier));
    } catch (_) {
      // Fall back to UTC if the platform timezone lookup fails — reminders
      // will still fire, just possibly off by the device's UTC offset until
      // this succeeds on a later launch.
    }

    const androidInit = AndroidInitializationSettings(smallIcon);
    const initSettings = InitializationSettings(android: androidInit);
    await _plugin.initialize(settings: initSettings);
    _initialized = true;
  }

  AndroidFlutterLocalNotificationsPlugin? get _android => _plugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

  /// Asks for notification permission (the system only ever shows its dialog
  /// once), and for exact-alarm access — but only the first time, or when
  /// [forceExactAlarmPrompt] is set from an explicit button press. Where
  /// it's not yet granted, requesting it opens a system settings page, which
  /// would be maddening to see on every single launch.
  Future<void> requestPermissions({bool forceExactAlarmPrompt = false}) async {
    await _android?.requestNotificationsPermission();
    final prefs = await SharedPreferences.getInstance();
    final asked = prefs.getBool(_askedExactAlarmKey) ?? false;
    if (forceExactAlarmPrompt || !asked) {
      await prefs.setBool(_askedExactAlarmKey, true);
      await _android?.requestExactAlarmsPermission();
    }
  }

  /// Whether the OS currently allows exact-time alarms for this app. On
  /// Android 12+ this needs a one-time user grant ("Alarms & reminders" in
  /// system settings). When it's off we fall back to inexact alarms (see
  /// [_scheduleMode]) so reminders still arrive — just possibly a few
  /// minutes late — instead of silently never firing.
  Future<bool?> exactAlarmsAllowed() => _android?.canScheduleExactNotifications() ?? Future.value(null);

  Future<AndroidScheduleMode> _scheduleMode() async {
    final exact = await exactAlarmsAllowed();
    return exact == false
        ? AndroidScheduleMode.inexactAllowWhileIdle
        : AndroidScheduleMode.exactAllowWhileIdle;
  }

  /// Whether scheduled reminders use a full-screen intent, which is what
  /// makes Android switch the screen on and show the notification on the
  /// lock screen instead of waiting silently until you press the power
  /// button. It's baked into each scheduled notification, so after changing
  /// it the whole schedule has to be rebuilt (StudyActivityService.refreshAll).
  Future<bool> wakeScreenEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_wakeScreenKey) ?? true;
  }

  Future<void> setWakeScreen(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_wakeScreenKey, enabled);
  }

  /// Android 14+ only lets calling/alarm apps use full-screen intents by
  /// default; everyone else needs the user to allow it in system settings.
  /// This opens that page. Without it reminders still arrive — as a normal
  /// heads-up — they just won't light up a sleeping screen.
  Future<void> requestScreenWakePermission() async {
    await _android?.requestFullScreenIntentPermission();
  }

  Future<int> pendingCount() async {
    await init();
    return (await _plugin.pendingNotificationRequests()).length;
  }

  /// Whether a notification may light up a sleeping screen: every kind can,
  /// gated only by the "Wake the screen for reminders" setting — nothing is
  /// hard-coded quiet, including the gentle post-study version.
  Future<bool> _mayWakeScreen(NotificationKind kind) => wakeScreenEnabled();

  /// The one place that turns a [NotificationKind] into how it looks and
  /// behaves. Everything that posts a notification goes through this.
  Future<NotificationDetails> _detailsFor(NotificationKind kind, String body) async {
    final ({
      String id,
      String name,
      String description,
      Importance importance,
      Priority priority,
      bool vibrate,
    }) c = switch (kind) {
      NotificationKind.reminder => (
          id: 'daily_study_reminder',
          name: 'Daily study reminder',
          description: 'Reminds you to study the Bible',
          importance: Importance.high,
          priority: Priority.high,
          vibrate: true,
        ),
      NotificationKind.urgent => (
          id: 'study_urgent',
          name: 'Urgent study reminders',
          description: 'Follow-ups when you still have not studied today',
          importance: Importance.max,
          priority: Priority.max,
          vibrate: true,
        ),
      // "Gentle" now only means softer wording — it vibrates and can wake
      // the screen exactly like the other same-day reminders, so it needs
      // the same importance/priority to actually trigger a heads-up.
      NotificationKind.gentle => (
          id: 'daily_study_gentle',
          name: 'Gentle daily reminders',
          description: 'A softer-worded reminder on days you have already studied',
          importance: Importance.high,
          priority: Priority.high,
          vibrate: true,
        ),
      NotificationKind.nudge => (
          id: 'inactivity_nudge',
          name: 'Inactivity reminders',
          description: 'Reminds you to come back and study after a few quiet days',
          importance: Importance.high,
          priority: Priority.high,
          vibrate: true,
        ),
      NotificationKind.nudgeDaily => (
          id: 'inactivity_nudge_daily',
          name: 'Persistent inactivity reminders',
          description: 'Daily nag once you have gone quiet for a week or more',
          importance: Importance.max,
          priority: Priority.max,
          vibrate: true,
        ),
      NotificationKind.test => (
          id: 'test_notifications',
          name: 'Test notifications',
          description: 'Manual "send now" test from Settings',
          importance: Importance.high,
          priority: Priority.high,
          vibrate: true,
        ),
    };

    return NotificationDetails(
      android: AndroidNotificationDetails(
        c.id,
        c.name,
        channelDescription: c.description,
        importance: c.importance,
        priority: c.priority,
        icon: smallIcon,
        color: AppTheme.emerald,
        fullScreenIntent: await _mayWakeScreen(kind),
        category: AndroidNotificationCategory.reminder,
        visibility: NotificationVisibility.public,
        styleInformation: body.isEmpty ? null : BigTextStyleInformation(body),
        enableVibration: true,
        vibrationPattern: c.vibrate ? Int64List.fromList([0, 500, 250, 500, 250, 500]) : null,
      ),
    );
  }

  /// Fires immediately — a pure diagnostic to confirm the notification
  /// channel/permission itself works, independent of the alarm scheduler.
  Future<void> showNow({required String title, required String body}) async {
    await init();
    await _plugin.show(
      id: 0,
      title: title,
      body: body.isEmpty ? null : body,
      notificationDetails: await _detailsFor(NotificationKind.test, body),
    );
  }

  /// Sends a notification exactly as it would really arrive (same channel,
  /// loudness, vibration, wake-up and icon) — used by Settings → "Preview
  /// notifications". With a [delay] it goes through the real alarm path, so
  /// you can lock your phone and watch the screen wake up.
  ///
  /// [slot] picks one of 100 reserved ids, so previewing one notification
  /// never replaces another that's still waiting on its delay.
  Future<void> preview({
    required int slot,
    required String title,
    required String body,
    required NotificationKind kind,
    Duration? delay,
  }) async {
    await init();
    final id = _previewIdBase + (slot % 100);
    final details = await _detailsFor(kind, body);
    if (delay == null) {
      await _plugin.show(
        id: id,
        title: title,
        body: body.isEmpty ? null : body,
        notificationDetails: details,
      );
    } else {
      await _plugin.zonedSchedule(
        id: id,
        title: title,
        body: body.isEmpty ? null : body,
        scheduledDate: tzNow().add(delay),
        notificationDetails: details,
        androidScheduleMode: await _scheduleMode(),
      );
    }
  }

  /// A one-shot through the *same* alarm path real reminders use — the
  /// definitive check that scheduled delivery works on this device.
  Future<void> scheduleTestIn(Duration delay, {required String title, required String body}) async {
    await init();
    await scheduleOneShot(
      id: scheduledTestId,
      title: title,
      body: body,
      when: tzNow().add(delay),
      kind: NotificationKind.urgent,
    );
  }

  /// A single study reminder at an exact moment. Reminders are scheduled
  /// individually for the coming days (rather than as weekly repeats) so
  /// every one can carry text that's accurate for *that* day — a repeating
  /// notification's text is frozen when it's scheduled, and would keep
  /// quoting a stale streak for weeks if you stopped opening the app.
  Future<void> scheduleReminderOnce({
    required int id,
    required tz.TZDateTime when,
    required String title,
    required String body,
    NotificationKind kind = NotificationKind.reminder,
  }) => scheduleOneShot(id: id, title: title, body: body, when: when, kind: kind);

  Future<void> cancel(int id) async {
    await init();
    await _plugin.cancel(id: id);
  }

  /// Cancels every *currently pending* notification whose id passes [test].
  /// Asking the plugin what's actually pending first means we only make a
  /// call per real notification, rather than one per id that could exist.
  Future<void> cancelPendingWhere(bool Function(int id) test) async {
    await init();
    for (final request in await _plugin.pendingNotificationRequests()) {
      if (test(request.id)) await _plugin.cancel(id: request.id);
    }
  }

  Future<void> cancelIds(Iterable<int> ids) async {
    await init();
    for (final id in ids) {
      await _plugin.cancel(id: id);
    }
  }

  /// A single future-dated notification.
  Future<void> scheduleOneShot({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime when,
    NotificationKind kind = NotificationKind.nudge,
  }) async {
    await init();
    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body.isEmpty ? null : body,
      scheduledDate: when,
      notificationDetails: await _detailsFor(kind, body),
      androidScheduleMode: await _scheduleMode(),
    );
  }

  /// A daily-repeating notification at a fixed time — the inactivity
  /// ladder's final rung once you're a week or more silent, so it keeps
  /// nagging every day until you come back and study.
  Future<void> scheduleDailyRepeating({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime firstOccurrence,
  }) async {
    await init();
    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body.isEmpty ? null : body,
      scheduledDate: firstOccurrence,
      notificationDetails: await _detailsFor(NotificationKind.nudgeDaily, body),
      androidScheduleMode: await _scheduleMode(),
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  tz.TZDateTime tzNow() => tz.TZDateTime.now(tz.local);
}
