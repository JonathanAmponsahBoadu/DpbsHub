import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/database.dart';
import '../../data/providers.dart';
import '../../data/repositories/attachments_repository.dart';
import '../../shared/widgets/attachments_strip.dart';

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
          final header = Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: AttachmentsStrip(ownerType: AttachmentOwner.talk, ownerId: talkId),
          );
          if (points.isEmpty) {
            return Column(
              children: [
                header,
                const Expanded(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Text(
                        'No outline points yet. Add each point as you go over the talk — '
                        'these become your quiz material.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
            itemCount: points.length + 1,
            itemBuilder: (context, i) {
              if (i == 0) return header;
              final p = points[i - 1];
              return Card(
                margin: const EdgeInsets.only(top: 12),
                child: ListTile(
                  leading: CircleAvatar(child: Text('$i')),
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
              await ref.read(studyActivityServiceProvider).recordActivity();
              if (dialogContext.mounted) Navigator.of(dialogContext).pop();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
