import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
                'day, or turn any day off.',
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
          const SizedBox(height: 20),
          _SectionLabel('AI-assisted quizzing'),
          Card(
            child: ListTile(
              leading: const Icon(Icons.smart_toy_outlined),
              title: const Text('AI providers (Gemini, Groq)'),
              subtitle: const Text(
                  'Coming soon — biometric-locked key vault, with the active provider always shown during a quiz and switchable here.'),
              enabled: false,
            ),
          ),
          const SizedBox(height: 20),
          _SectionLabel('Cloud sync'),
          Card(
            child: ListTile(
              leading: const Icon(Icons.cloud_outlined),
              title: const Text('Backup & sync'),
              subtitle: const Text('Coming soon — your study data, synced across devices.'),
              enabled: false,
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
