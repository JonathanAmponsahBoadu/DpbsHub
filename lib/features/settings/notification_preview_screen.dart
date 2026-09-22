import 'package:flutter/material.dart';

import '../../core/notifications/notification_copy.dart';
import '../../core/notifications/notification_service.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widget/study_widget_service.dart';

/// Stands in for your real streak in the streak-aware messages.
const _sampleStreak = 5;

class _PreviewItem {
  const _PreviewItem({
    required this.label,
    required this.when,
    required this.text,
    required this.kind,
  });

  final String label;
  final String when;
  final NotificationText text;
  final NotificationKind kind;
}

class _PreviewGroup {
  const _PreviewGroup(this.title, this.blurb, this.items);
  final String title;
  final String blurb;
  final List<_PreviewItem> items;
}

/// Every notification, built from the same NotificationCopy the real
/// scheduler uses — so this list can never drift from what actually arrives.
List<_PreviewGroup> _buildGroups() {
  const n = _sampleStreak;
  const followUpTimes = ['1 hour after the reminder', '2 hours after', '3 hours after'];

  return [
    _PreviewGroup(
      'Same-day reminders',
      "What you get on a day you haven't studied yet. Where a message mentions a streak, "
          '$n stands in for your real one.',
      [
        _PreviewItem(
          label: 'Reminder — with a streak',
          when: 'Your set time (default 6:00 pm)',
          text: NotificationCopy.main(n),
          kind: NotificationKind.reminder,
        ),
        _PreviewItem(
          label: 'Reminder — no streak',
          when: 'Your set time (default 6:00 pm)',
          text: NotificationCopy.main(0),
          kind: NotificationKind.reminder,
        ),
        _PreviewItem(
          label: 'Follow-up 1',
          when: followUpTimes[0],
          text: NotificationCopy.followUp(0, n),
          kind: NotificationKind.urgent,
        ),
        _PreviewItem(
          label: 'Follow-up 2 — with a streak',
          when: followUpTimes[1],
          text: NotificationCopy.followUp(1, n),
          kind: NotificationKind.urgent,
        ),
        _PreviewItem(
          label: 'Follow-up 2 — no streak',
          when: followUpTimes[1],
          text: NotificationCopy.followUp(1, 0),
          kind: NotificationKind.urgent,
        ),
        _PreviewItem(
          label: 'Follow-up 3 — with a streak',
          when: followUpTimes[2],
          text: NotificationCopy.followUp(2, n),
          kind: NotificationKind.urgent,
        ),
        _PreviewItem(
          label: 'Follow-up 3 — no streak',
          when: followUpTimes[2],
          text: NotificationCopy.followUp(2, 0),
          kind: NotificationKind.urgent,
        ),
        _PreviewItem(
          label: 'Streak alert',
          when: '9:30 pm, only while you have a streak to lose',
          text: NotificationCopy.streakEvening(n),
          kind: NotificationKind.urgent,
        ),
        _PreviewItem(
          label: 'Final streak alert',
          when: '11:15 pm, only while you have a streak to lose',
          text: NotificationCopy.streakFinal(n),
          kind: NotificationKind.urgent,
        ),
      ],
    ),
    _PreviewGroup(
      "Softer wording — after you've studied",
      'Replaces the group above for the rest of a day you have already studied (notes, '
          'verses, a quiz or "Log other study"). Same pop-up, vibration and screen wake-up as '
          'any other reminder — just no streak alerts and friendlier wording.',
      [
        _PreviewItem(
          label: 'Reminder',
          when: 'Your set time',
          text: NotificationCopy.gentleMain,
          kind: NotificationKind.gentle,
        ),
        for (var i = 0; i < 3; i++)
          _PreviewItem(
            label: 'Follow-up ${i + 1}',
            when: followUpTimes[i],
            text: NotificationCopy.gentleFollowUp(i),
            kind: NotificationKind.gentle,
          ),
      ],
    ),
    _PreviewGroup(
      'Multi-day nudges',
      'Sent at noon when you go quiet for days. They start over the moment you study.',
      [
        for (final entry in NotificationCopy.inactivityRungs.entries)
          _PreviewItem(
            label: 'After ${entry.key} ${entry.key == 1 ? 'day' : 'days'} of silence',
            when: 'Noon, ${entry.key} ${entry.key == 1 ? 'day' : 'days'} after you last studied',
            text: entry.value,
            kind: NotificationKind.nudge,
          ),
        _PreviewItem(
          label: 'Day 6 onward',
          when: 'Every day at noon until you study again',
          text: NotificationCopy.inactivityDaily,
          kind: NotificationKind.nudgeDaily,
        ),
      ],
    ),
    _PreviewGroup(
      'Tests',
      'Only ever sent when you press the buttons under Settings → reminders.',
      [
        _PreviewItem(
          label: 'Send test now',
          when: 'Instantly',
          text: NotificationCopy.testInstant,
          kind: NotificationKind.test,
        ),
        _PreviewItem(
          label: 'Test in 1 minute',
          when: 'One minute after you press it',
          text: NotificationCopy.testScheduled,
          kind: NotificationKind.urgent,
        ),
      ],
    ),
  ];
}

List<String> _tagsFor(NotificationKind kind) => switch (kind) {
      NotificationKind.reminder => const ['Pop-up', 'Vibrates', 'Can wake screen'],
      NotificationKind.urgent => const ['Pop-up', 'Loud + vibrates', 'Can wake screen'],
      NotificationKind.gentle => const ['Pop-up', 'Vibrates', 'Can wake screen'],
      NotificationKind.nudge => const ['Pop-up', 'Vibrates', 'Can wake screen'],
      NotificationKind.nudgeDaily => const ['Pop-up', 'Loud + vibrates', 'Can wake screen'],
      NotificationKind.test => const ['Pop-up', 'Vibrates', 'Can wake screen'],
    };

/// Settings → "Preview notifications & widget": every notification and every
/// widget look, sent to your phone on demand so you can judge them by eye.
class NotificationPreviewScreen extends StatefulWidget {
  const NotificationPreviewScreen({super.key});

  @override
  State<NotificationPreviewScreen> createState() => _NotificationPreviewScreenState();
}

class _NotificationPreviewScreenState extends State<NotificationPreviewScreen> {
  bool _delay = false;
  final _groups = _buildGroups();

  void _toast(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _show(int slot, _PreviewItem item) async {
    try {
      await NotificationService.instance.preview(
        slot: slot,
        title: item.text.title,
        body: item.text.body,
        kind: item.kind,
        delay: _delay ? const Duration(seconds: 10) : null,
      );
      _toast(_delay ? 'Sending in 10 seconds — lock your phone now' : 'Sent to your phone');
    } catch (e) {
      _toast("Couldn't send it: $e");
    }
  }

  Future<void> _setWidgetLook(String? state, String name) async {
    await StudyWidgetService.setPreview(state);
    _toast(state == null
        ? 'Widget is back to your real streak'
        : 'Widget switched to "$name" — check your home screen');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant);
    var slot = 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Preview')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tap Show and the notification is sent to your phone right now, exactly as '
                    'it would really arrive — same sound, pop-up and icon.',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Icons: every notification carries a small open-book icon (white in the '
                    "status bar, emerald in the shade). The emoji at the start of a title — 📖 🔥 "
                    '⏰ ⚠️ 🚨 😟 😢 — is part of the message itself.',
                    style: muted,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: SwitchListTile(
              title: const Text('Wait 10 seconds first'),
              subtitle: const Text(
                'Turn this on, tap Show, then lock your phone — you can watch the screen '
                'wake up the way a real reminder does.',
              ),
              value: _delay,
              onChanged: (v) => setState(() => _delay = v),
            ),
          ),
          for (final group in _groups) ...[
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 0, 4, 4),
              child: Text(
                group.title,
                style: theme.textTheme.titleMedium
                    ?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w800),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 0, 4, 10),
              child: Text(group.blurb, style: muted),
            ),
            for (final item in group.items) ...[
              _NotificationCard(item: item, onShow: (s) => _show(s, item), slot: slot++),
              const SizedBox(height: 8),
            ],
          ],
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 4),
            child: Text(
              'Home-screen widget',
              style: theme.textTheme.titleMedium
                  ?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w800),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'These buttons switch the real widget on your home screen to each look, so '
                    'you can see it properly. Add the widget first if you have not. It returns '
                    'to your real streak by itself after ten minutes.',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  FilledButton.tonalIcon(
                    onPressed: () async {
                      if (await StudyWidgetService.canPin()) {
                        await StudyWidgetService.requestPin();
                      } else {
                        _toast('Long-press your home screen → Widgets → DpbsHub to add it.');
                      }
                    },
                    icon: const Icon(Icons.widgets_outlined, size: 18),
                    label: const Text('Add widget to home screen'),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _WidgetLookButton(
                        label: 'Studied today',
                        detail: 'Emerald',
                        onPressed: () => _setWidgetLook('studied', 'Studied today'),
                      ),
                      _WidgetLookButton(
                        label: 'Streak at risk',
                        detail: 'Orange',
                        onPressed: () => _setWidgetLook('atrisk', 'Streak at risk'),
                      ),
                      _WidgetLookButton(
                        label: 'About to break',
                        detail: 'Orange, blinking',
                        onPressed: () => _setWidgetLook('urgent', 'About to break'),
                      ),
                      _WidgetLookButton(
                        label: 'No streak yet',
                        detail: 'Deep green',
                        onPressed: () => _setWidgetLook('idle', 'No streak yet'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () => _setWidgetLook(null, ''),
                    icon: const Icon(Icons.restart_alt, size: 18),
                    label: const Text('Back to my real streak'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// One notification, drawn the way Android draws it: small icon badge, bold
/// title, body — plus when it's sent and how it behaves.
class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.item, required this.slot, required this.onShow});

  final _PreviewItem item;
  final int slot;
  final void Function(int slot) onShow;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(color: AppTheme.emerald, shape: BoxShape.circle),
                  child: const Icon(Icons.menu_book_rounded, size: 17, color: Colors.white),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.text.title,
                        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.text.body.isEmpty ? '(no second line)' : item.text.body,
                        style: item.text.body.isEmpty
                            ? muted?.copyWith(fontStyle: FontStyle.italic)
                            : theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(item.label, style: muted?.copyWith(fontWeight: FontWeight.w700)),
            Text('When: ${item.when}', style: muted),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      for (final tag in _tagsFor(item.kind))
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(tag, style: theme.textTheme.labelSmall),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.tonal(
                  onPressed: () => onShow(slot),
                  child: const Text('Show'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _WidgetLookButton extends StatelessWidget {
  const _WidgetLookButton({required this.label, required this.detail, required this.onPressed});
  final String label;
  final String detail;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
          Text(detail, style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }
}
