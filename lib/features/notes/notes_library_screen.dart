import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../data/local/database.dart';
import '../../data/providers.dart';
import '../../data/repositories/notes_repository.dart';
import 'note_edit_sheet.dart';

final _notesProvider = StreamProvider<List<NoteWithTags>>((ref) {
  return ref.watch(notesRepositoryProvider).watchAllNotes();
});

final _tagsProvider = StreamProvider<List<Tag>>((ref) {
  return ref.watch(notesRepositoryProvider).watchTags();
});

final _tagFilterProvider = StateProvider<String?>((ref) => null);
final _searchQueryProvider = StateProvider<String>((ref) => '');

class NotesLibraryScreen extends ConsumerWidget {
  const NotesLibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(_notesProvider);
    final tagsAsync = ref.watch(_tagsProvider);
    final tagFilter = ref.watch(_tagFilterProvider);
    final query = ref.watch(_searchQueryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Notes Library')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showNoteEditSheet(context),
        icon: const Icon(Icons.add),
        label: const Text('Add note'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search notes...',
              ),
              onChanged: (v) => ref.read(_searchQueryProvider.notifier).state = v,
            ),
          ),
          tagsAsync.maybeWhen(
            data: (tags) => tags.isEmpty
                ? const SizedBox.shrink()
                : SizedBox(
                    height: 44,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        for (final tag in tags)
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(tag.name),
                              selected: tagFilter == tag.id,
                              onSelected: (sel) => ref
                                  .read(_tagFilterProvider.notifier)
                                  .state = sel ? tag.id : null,
                            ),
                          ),
                      ],
                    ),
                  ),
            orElse: () => const SizedBox.shrink(),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: notesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('$e')),
              data: (notes) {
                var filtered = notes;
                if (tagFilter != null) {
                  filtered = filtered
                      .where((n) => n.tags.any((t) => t.id == tagFilter))
                      .toList();
                }
                if (query.trim().isNotEmpty) {
                  final q = query.toLowerCase();
                  filtered = filtered
                      .where((n) => n.note.noteText.toLowerCase().contains(q))
                      .toList();
                }
                if (filtered.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Text(
                        'No notes yet. Add one while logging a scripture in the Bible tab.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final n = filtered[i];
                    return Card(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(22),
                        onTap: () => showNoteEditSheet(context, existing: n),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (n.entry != null)
                                Text(
                                  'Ch ${n.entry!.chapter}:${n.entry!.verseStart}'
                                  '${n.entry!.verseEnd != n.entry!.verseStart ? '-${n.entry!.verseEnd}' : ''}',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              const SizedBox(height: 4),
                              Text(n.note.noteText),
                              if (n.tags.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 6,
                                  children: [
                                    for (final t in n.tags)
                                      Chip(
                                        label: Text(t.name, style: const TextStyle(fontSize: 12)),
                                        visualDensity: VisualDensity.compact,
                                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
