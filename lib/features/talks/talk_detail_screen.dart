import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/database.dart';
import '../../data/providers.dart';

final _pointsProvider = StreamProvider.family<List<TalkPoint>, String>((ref, talkId) {
  return ref.watch(talksRepositoryProvider).watchPoints(talkId);
});

class TalkDetailScreen extends ConsumerWidget {
  const TalkDetailScreen({super.key, required this.talkId});
  final String talkId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pointsAsync = ref.watch(_pointsProvider(talkId));

    return Scaffold(
      appBar: AppBar(title: const Text('Talk outline')),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null, // avoid Hero-tag collisions with FABs on other tabs kept alive in the IndexedStack
        onPressed: () => _addPointDialog(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Add point'),
      ),
      body: pointsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('$e')),
        data: (points) {
          if (points.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  'No outline points yet. Add each point as you go over the talk — '
                  'these become your quiz material.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
            itemCount: points.length,
            itemBuilder: (context, i) {
              final p = points[i];
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: CircleAvatar(child: Text('${i + 1}')),
                  title: Text(p.pointText),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _addPointDialog(BuildContext context, WidgetRef ref) async {
    final ctrl = TextEditingController();
    await showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add outline point'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          maxLines: 3,
          decoration: const InputDecoration(hintText: 'What was this point about?'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              if (ctrl.text.trim().isEmpty) return;
              await ref
                  .read(talksRepositoryProvider)
                  .addPoint(talkId: talkId, pointText: ctrl.text.trim());
              if (dialogContext.mounted) Navigator.of(dialogContext).pop();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
