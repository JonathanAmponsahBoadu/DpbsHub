import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../data/local/database.dart';
import '../../data/providers.dart';

final _talksProvider = StreamProvider<List<Talk>>((ref) {
  return ref.watch(talksRepositoryProvider).watchTalks();
});

class TalkListScreen extends ConsumerWidget {
  const TalkListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final talksAsync = ref.watch(_talksProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Public Talks')),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null, // avoid Hero-tag collisions with FABs on other tabs kept alive in the IndexedStack
        onPressed: () => _showNewTalkDialog(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('New talk'),
      ),
      body: talksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('$e')),
        data: (talks) {
          if (talks.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  'No talks logged yet. Add one and capture its outline points to review and quiz on later.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
            itemCount: talks.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final t = talks[i];
              return Card(
                child: ListTile(
                  title: Text(t.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(
                    [
                      if (t.speaker != null && t.speaker!.isNotEmpty) t.speaker,
                      DateFormat.yMMMd().format(t.date),
                    ].join(' · '),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/talks/${t.id}'),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _showNewTalkDialog(BuildContext context, WidgetRef ref) async {
    final titleCtrl = TextEditingController();
    final speakerCtrl = TextEditingController();
    DateTime date = DateTime.now();

    await showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setState) => AlertDialog(
          title: const Text('New talk'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(labelText: 'Talk title'),
                autofocus: true,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: speakerCtrl,
                decoration: const InputDecoration(labelText: 'Speaker (optional)'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: Text(DateFormat.yMMMd().format(date))),
                  TextButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: dialogContext,
                        initialDate: date,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now().add(const Duration(days: 1)),
                      );
                      if (picked != null) setState(() => date = picked);
                    },
                    child: const Text('Change date'),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                if (titleCtrl.text.trim().isEmpty) return;
                await ref.read(talksRepositoryProvider).createTalk(
                      title: titleCtrl.text.trim(),
                      speaker: speakerCtrl.text.trim().isEmpty ? null : speakerCtrl.text.trim(),
                      date: date,
                    );
                if (dialogContext.mounted) Navigator.of(dialogContext).pop();
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}
