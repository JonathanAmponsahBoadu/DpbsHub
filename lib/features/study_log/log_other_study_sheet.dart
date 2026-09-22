import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import 'study_log_kinds.dart';

/// Bottom sheet for logging study that doesn't leave a note behind —
/// watching JW Broadcasting, restudying, drawing, family worship. It counts
/// toward your streak and quiets the rest of today's reminders, exactly like
/// saving a note would.
Future<void> showLogOtherStudySheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => const _LogOtherStudySheet(),
  );
}

class _LogOtherStudySheet extends ConsumerStatefulWidget {
  const _LogOtherStudySheet();

  @override
  ConsumerState<_LogOtherStudySheet> createState() => _LogOtherStudySheetState();
}

class _LogOtherStudySheetState extends ConsumerState<_LogOtherStudySheet> {
  String _kind = studyLogKinds.first.key;
  final _noteCtrl = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);

    // Grab everything we need from `ref`/`context` up front: the sheet is
    // gone by the time the undo snackbar's button can be pressed.
    final repo = ref.read(studyLogRepositoryProvider);
    final activity = ref.read(studyActivityServiceProvider);
    final messenger = ScaffoldMessenger.of(context);
    final label = studyLogKindFor(_kind).label;
    final note = _noteCtrl.text.trim();

    final id = await repo.add(kind: _kind, note: note.isEmpty ? null : note);
    await activity.recordActivity();

    if (!mounted) return;
    Navigator.of(context).pop();
    messenger.showSnackBar(
      SnackBar(
        content: Text('Logged: $label ✓'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () async {
            await repo.remove(id);
            await activity.refreshAll();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Log other study', style: theme.textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(
              'Not every kind of study leaves a note. This counts toward your streak just '
              'the same.',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final kind in studyLogKinds)
                  ChoiceChip(
                    avatar: Icon(kind.icon, size: 18),
                    label: Text(kind.label),
                    selected: _kind == kind.key,
                    onSelected: (_) => setState(() => _kind = kind.key),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _noteCtrl,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'What did you do? (optional)',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Log it'),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
