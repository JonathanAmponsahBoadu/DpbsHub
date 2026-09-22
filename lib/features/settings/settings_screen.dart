import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/notifications/notification_copy.dart';
import '../../core/notifications/notification_service.dart';
import '../../core/widget/study_widget_service.dart';
import '../../data/local/database.dart';
import '../../data/providers.dart';

const _weekdayNames = {
  1: 'Monday',
  2: 'Tuesday',
  3: 'Wednesday',
  4: 'Thursday',
  5: 'Friday',
  6: 'Saturday',
  7: 'Sunday',
};

final _reminderSettingsProvider =
    StreamProvider((ref) => ref.watch(remindersRepositoryProvider).watchAll());

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final remindersAsync = ref.watch(_reminderSettingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionLabel('Appearance'),
          Card(
            child: Column(
              children: [
                RadioListTile<ThemeMode>(
                  title: const Text('Follow system'),
                  value: ThemeMode.system,
                  groupValue: themeMode,
                  onChanged: (v) => ref.read(themeModeProvider.notifier).state = v!,
                ),
                RadioListTile<ThemeMode>(
                  title: const Text('Light'),
                  value: ThemeMode.light,
                  groupValue: themeMode,
                  onChanged: (v) => ref.read(themeModeProvider.notifier).state = v!,
                ),
                RadioListTile<ThemeMode>(
                  title: const Text('Dark'),
                  value: ThemeMode.dark,
                  groupValue: themeMode,
                  onChanged: (v) => ref.read(themeModeProvider.notifier).state = v!,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _SectionLabel('Daily study reminder'),
          Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Text(
                'A notification each day to study your Bible — set a different time per '
                'day, or turn any day off (which also stops that day\'s follow-ups and '
                'alerts). If you have not studied, it follows up every hour (three more '
                'times), and if you have a streak you also get alerts at 9:30pm and 11:15pm '
                'before it breaks. Once you have studied — by notes, verses, a quiz, or '
                '"Log other study" — the rest of that day\'s reminders turn into short, '
                'friendlier ones (still with the usual vibration and screen wake-up) and the '
                'streak alerts stop.',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            ),
          ),
          const SizedBox(height: 8),
          remindersAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Text('$e'),
            data: (rows) => Card(
              child: Column(
                children: [
                  for (final row in rows) _ReminderRow(row: row),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          const _NotificationDiagnosticsCard(),
          const SizedBox(height: 8),
          const _WakeScreenCard(),
          const SizedBox(height: 20),
          _SectionLabel('Streak nudges'),
          Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Text(
                "If you go quiet for days, DpbsHub nudges you back — escalating messages at "
                "1, 2, 3 and 5 days of silence, then a daily \"Your study habit is fading\" from day 6 on. It all "
                'resets the moment you log a verse, note, or finish a quiz.',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const _NudgeToggleCard(),
          const SizedBox(height: 8),
          const _WidgetCard(),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.visibility_outlined),
              title: const Text('Preview notifications & widget'),
              subtitle: const Text(
                'See every notification and every widget look, exactly as they appear.',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/settings/previews'),
            ),
          ),
          const SizedBox(height: 20),
          _SectionLabel('AI-assisted quizzing'),
          Card(
            child: ListTile(
              leading: const Icon(Icons.smart_toy_outlined),
              title: const Text('AI providers (Gemini, Groq)'),
              subtitle: const Text(
                  'Fingerprint/face-locked key vault. Pick which provider generates and grades your AI quiz questions.'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/settings/ai-providers'),
            ),
          ),
          const SizedBox(height: 20),
          _SectionLabel('Cloud sync'),
          Card(
            child: ListTile(
              leading: const Icon(Icons.cloud_outlined),
              title: const Text('Account & sync'),
              subtitle: const Text('Sign in with Google to back up and sync across devices.'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/settings/account'),
            ),
          ),
          const SizedBox(height: 20),
          _SectionLabel('About'),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'DpbsHub stores only the scripture text you personally type or paste in while '
                'studying — it never bundles or scrapes NWT content. Use the "Read on jw.org" '
                'link on any chapter to read the official text.',
                style: TextStyle(height: 1.4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReminderRow extends ConsumerWidget {
  const _ReminderRow({required this.row});
  final ReminderSetting row;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final time = TimeOfDay(hour: row.hour, minute: row.minute);
    return SwitchListTile(
      title: Text(_weekdayNames[row.weekday]!),
      subtitle: Text(row.enabled ? time.format(context) : 'Off'),
      value: row.enabled,
      onChanged: (v) => ref.read(remindersRepositoryProvider).setEnabled(row.weekday, v),
      secondary: row.enabled
          ? TextButton(
              onPressed: () async {
                final picked = await showTimePicker(context: context, initialTime: time);
                if (picked != null) {
                  await ref
                      .read(remindersRepositoryProvider)
                      .setTime(row.weekday, picked.hour, picked.minute);
                }
              },
              child: const Text('Change'),
            )
          : null,
    );
  }
}

/// Diagnostics for the reminders. Scheduled notifications can fail for
/// reasons that have nothing to do with the code — a missing exact-alarm
/// grant, or an Android OEM skin (Transsion/HiOS on the dev device) killing
/// background alarms — and from the outside every one of those looks like
/// "nothing happened". This card makes each cause visible and testable.
class _NotificationDiagnosticsCard extends StatefulWidget {
  const _NotificationDiagnosticsCard();
  @override
  State<_NotificationDiagnosticsCard> createState() => _NotificationDiagnosticsCardState();
}

class _NotificationDiagnosticsCardState extends State<_NotificationDiagnosticsCard> {
  bool? _exactAlarmsAllowed;
  int? _pending;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final service = NotificationService.instance;
    final allowed = await service.exactAlarmsAllowed();
    int? pending;
    try {
      pending = await service.pendingCount();
    } catch (_) {}
    if (mounted) {
      setState(() {
        _exactAlarmsAllowed = allowed;
        _pending = pending;
      });
    }
  }

  void _toast(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _openSystemScreen(String action, {String? data}) async {
    try {
      await AndroidIntent(action: action, data: data).launch();
    } catch (e) {
      _toast("Couldn't open that settings screen: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant);
    final error = NotificationService.instance.lastError;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _exactAlarmsAllowed == false ? Icons.warning_amber : Icons.check_circle_outline,
                  color: _exactAlarmsAllowed == false
                      ? Colors.amber.shade700
                      : theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    switch (_exactAlarmsAllowed) {
                      true => 'Exact alarms: allowed',
                      false => 'Exact alarms: not allowed — reminders may arrive a few minutes '
                          'late. Tap "Allow exact alarms" below.',
                      null => 'Checking exact-alarm permission…',
                    },
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _pending == null
                  ? 'Checking scheduled reminders…'
                  : '$_pending reminders/nudges currently scheduled',
              style: theme.textTheme.bodyMedium,
            ),
            if (error != null) ...[
              const SizedBox(height: 8),
              Text(
                'Scheduling error: $error',
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error),
              ),
            ],
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.tonal(
                  onPressed: () async {
                    await NotificationService.instance
                        .requestPermissions(forceExactAlarmPrompt: true);
                    await _refresh();
                  },
                  child: const Text('Allow exact alarms'),
                ),
                OutlinedButton(
                  onPressed: () async {
                    await NotificationService.instance.showNow(
                      title: NotificationCopy.testInstant.title,
                      body: NotificationCopy.testInstant.body,
                    );
                    _toast('Test notification sent');
                  },
                  child: const Text('Send test now'),
                ),
                OutlinedButton(
                  onPressed: () async {
                    try {
                      await NotificationService.instance.scheduleTestIn(
                        const Duration(minutes: 1),
                        title: NotificationCopy.testScheduled.title,
                        body: NotificationCopy.testScheduled.body,
                      );
                      _toast('Scheduled — lock your phone and wait about a minute');
                    } catch (e) {
                      _toast('Could not schedule: $e');
                    }
                    await _refresh();
                  },
                  child: const Text('Test in 1 minute'),
                ),
                OutlinedButton(
                  onPressed: () => _openSystemScreen(
                    'android.settings.IGNORE_BATTERY_OPTIMIZATION_SETTINGS',
                  ),
                  child: const Text('Battery settings'),
                ),
                OutlinedButton(
                  onPressed: () => _openSystemScreen(
                    'android.settings.APPLICATION_DETAILS_SETTINGS',
                    data: 'package:com.dpbshub.dpbshub',
                  ),
                  child: const Text('App settings'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              '"Test in 1 minute" goes through the same alarm scheduler as your real '
              "reminders — if it arrives, they will too. If it doesn't, the phone is "
              'blocking background alarms: on Tecno/Infinix/itel (HiOS) open App settings → '
              'Battery → "No restrictions", and turn on Auto-start / "Run in background".',
              style: muted,
            ),
          ],
        ),
      ),
    );
  }
}

/// Lets reminders light up a sleeping screen and show on the lock screen,
/// the way a messaging app's notifications do. Android only allows that for
/// "full-screen intent" notifications, which on Android 14+ also need the
/// user to allow it once in system settings.
class _WakeScreenCard extends ConsumerStatefulWidget {
  const _WakeScreenCard();
  @override
  ConsumerState<_WakeScreenCard> createState() => _WakeScreenCardState();
}

class _WakeScreenCardState extends ConsumerState<_WakeScreenCard> {
  bool? _enabled;

  @override
  void initState() {
    super.initState();
    NotificationService.instance.wakeScreenEnabled().then((v) {
      if (mounted) setState(() => _enabled = v);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Wake the screen for reminders'),
            subtitle: const Text(
              'Lights up your lock screen when a reminder arrives, like a messaging app, '
              'instead of waiting until you press the power button.',
            ),
            value: _enabled ?? true,
            onChanged: _enabled == null
                ? null
                : (v) async {
                    setState(() => _enabled = v);
                    await NotificationService.instance.setWakeScreen(v);
                    // The setting is baked into each scheduled notification,
                    // so rebuild the whole schedule to apply it.
                    await ref.read(studyActivityServiceProvider).refreshAll();
                  },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton.icon(
                onPressed: NotificationService.instance.requestScreenWakePermission,
                icon: const Icon(Icons.lock_open_outlined, size: 18),
                label: const Text('Allow screen wake-up (system permission)'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NudgeToggleCard extends ConsumerStatefulWidget {
  const _NudgeToggleCard();
  @override
  ConsumerState<_NudgeToggleCard> createState() => _NudgeToggleCardState();
}

class _NudgeToggleCardState extends ConsumerState<_NudgeToggleCard> {
  bool? _enabled;

  @override
  void initState() {
    super.initState();
    ref.read(inactivityNudgeServiceProvider).isEnabled().then((v) {
      if (mounted) setState(() => _enabled = v);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SwitchListTile(
        title: const Text('Persistent inactivity nudges'),
        subtitle: const Text('Escalating reminders if you stop studying'),
        value: _enabled ?? true,
        onChanged: _enabled == null
            ? null
            : (v) async {
                setState(() => _enabled = v);
                await ref.read(inactivityNudgeServiceProvider).setEnabled(v);
                // Turning it back on rebuilds the ladder from your real
                // last activity rather than starting from "now".
                if (v) await ref.read(studyActivityServiceProvider).refreshAll();
              },
      ),
    );
  }
}

/// One-tap "put the streak widget on my home screen".
class _WidgetCard extends StatelessWidget {
  const _WidgetCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.widgets_outlined),
        title: const Text('Home-screen widget'),
        subtitle: const Text(
          'Your streak on your home screen — it turns orange and counts down the '
          "hours when today's study is still waiting.",
        ),
        trailing: FilledButton(
          onPressed: () async {
            final supported = await StudyWidgetService.canPin();
            if (!context.mounted) return;
            if (supported) {
              await StudyWidgetService.requestPin();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Long-press your home screen → Widgets → DpbsHub to add it.',
                  ),
                ),
              );
            }
          },
          child: const Text('Add'),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .labelLarge
            ?.copyWith(color: Theme.of(context).colorScheme.primary),
      ),
    );
  }
}
