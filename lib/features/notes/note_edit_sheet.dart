import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/database.dart';
import '../../data/providers.dart';
import '../../data/repositories/attachments_repository.dart';
import '../../data/repositories/notes_repository.dart';
import '../../shared/widgets/attachments_strip.dart';

/// Bottom sheet to create or edit a standalone note from the Notes page —
/// optionally attached to a scripture you've already logged, with full
/// multi-tag support (add/remove any number of tags, same as the Bible tab's
/// quick-add flow).
Future<void> showNoteEditSheet(BuildContext context, {NoteWithTags? existing}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => _NoteEditSheet(existing: existing),
  );
}

final _allEntriesProvider = StreamProvider((ref) => ref.watch(bibleRepositoryProvider).watchAllEntries());
final _allBooksProvider = StreamProvider((ref) => ref.watch(bibleRepositoryProvider).watchBooks());
final _allTagsProvider = StreamProvider((ref) => ref.watch(notesRepositoryProvider).watchTags());

class _NoteEditSheet extends ConsumerStatefulWidget {
  const _NoteEditSheet({this.existing});
  final NoteWithTags? existing;

  @override
  ConsumerState<_NoteEditSheet> createState() => _NoteEditSheetState();
}

class _NoteEditSheetState extends ConsumerState<_NoteEditSheet> {
  late final _textCtrl = TextEditingController(text: widget.existing?.note.noteText ?? '');
  final _newTagCtrl = TextEditingController();
  late final Set<String> _selectedTagIds = {
    for (final t in widget.existing?.tags ?? const <Tag>[]) t.id,
  };
  StudyEntry? _attachedEntry;
  bool _saving = false;
  bool _entryInitialized = false;

  @override
  Widget build(BuildContext context) {
    final tagsAsync = ref.watch(_allTagsProvider);
    if (!_entryInitialized && widget.existing?.entry != null) {
      _attachedEntry = widget.existing!.entry;
      _entryInitialized = true;
    }

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
            Text(
              widget.existing == null ? 'Add a note' : 'Edit note',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _textCtrl,
              maxLines: 4,
              autofocus: widget.existing == null,
              decoration: const InputDecoration(
                labelText: 'What did you learn?',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 14),
            Text('Attach a scripture (optional)', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            _attachedEntry == null
                ? OutlinedButton.icon(
                    onPressed: _pickEntry,
                    icon: const Icon(Icons.menu_book_outlined),
                    label: const Text('Choose a logged scripture'),
                  )
                : Chip(
                    label: Text(_entryLabel(_attachedEntry!)),
                    onDeleted: () => setState(() => _attachedEntry = null),
                  ),
            const SizedBox(height: 16),
            Text('Tags', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            tagsAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
              data: (tags) => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final tag in tags)
                    FilterChip(
                      label: Text(tag.name),
                      selected: _selectedTagIds.contains(tag.id),
                      onSelected: (sel) => setState(() {
                        sel ? _selectedTagIds.add(tag.id) : _selectedTagIds.remove(tag.id);
                      }),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _newTagCtrl,
                    decoration: const InputDecoration(labelText: 'New tag'),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filledTonal(
                  icon: const Icon(Icons.add),
                  onPressed: () async {
                    final name = _newTagCtrl.text.trim();
                    if (name.isEmpty) return;
                    final tag = await ref.read(notesRepositoryProvider).createTag(name);
                    setState(() {
                      _selectedTagIds.add(tag.id);
                      _newTagCtrl.clear();
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (widget.existing != null)
              AttachmentsStrip(
                ownerType: AttachmentOwner.studyNote,
                ownerId: widget.existing!.note.id,
              )
            else
              Text(
                'Save this note first, then reopen it to attach a photo, video or voice note.',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(widget.existing == null ? 'Save note' : 'Save changes'),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  String _entryLabel(StudyEntry e) {
    final books = ref.read(_allBooksProvider).value ?? const <Book>[];
    final book = books.where((b) => b.id == e.bookId).firstOrNull;
    final name = book == null ? 'Book ${e.bookId}' : (e.language == 'tw' ? book.nameTw : book.nameEn);
    return e.verseStart == e.verseEnd
        ? '$name ${e.chapter}:${e.verseStart}'
        : '$name ${e.chapter}:${e.verseStart}-${e.verseEnd}';
  }

  Future<void> _pickEntry() async {
    final picked = await showModalBottomSheet<StudyEntry>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const _EntryPickerSheet(),
    );
    if (picked != null) setState(() => _attachedEntry = picked);
  }

  Future<void> _save() async {
    if (_textCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter some note text')));
      return;
    }
    setState(() => _saving = true);
    final repo = ref.read(notesRepositoryProvider);
    if (widget.existing == null) {
      await repo.addNote(
        noteText: _textCtrl.text.trim(),
        source: 'personalStudy',
        studyEntryId: _attachedEntry?.id,
        tagIds: _selectedTagIds.toList(),
      );
    } else {
      await repo.updateNote(
        id: widget.existing!.note.id,
        noteText: _textCtrl.text.trim(),
        studyEntryId: _attachedEntry?.id,
        tagIds: _selectedTagIds.toList(),
      );
    }
    await ref.read(studyActivityServiceProvider).recordActivity();
    if (mounted) Navigator.of(context).pop();
  }
}

class _EntryPickerSheet extends ConsumerStatefulWidget {
  const _EntryPickerSheet();

  @override
  ConsumerState<_EntryPickerSheet> createState() => _EntryPickerSheetState();
}

class _EntryPickerSheetState extends ConsumerState<_EntryPickerSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final entriesAsync = ref.watch(_allEntriesProvider);
    final booksAsync = ref.watch(_allBooksProvider);

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Choose a scripture', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search by book...'),
              onChanged: (v) => setState(() => _query = v.toLowerCase()),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: entriesAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, st) => Center(child: Text('$e')),
                data: (entries) {
                  final books = booksAsync.value ?? const <Book>[];
                  final bookNameById = {for (final b in books) b.id: b.nameEn};
                  final filtered = entries.where((e) {
                    if (_query.isEmpty) return true;
                    final name = bookNameById[e.bookId]?.toLowerCase() ?? '';
                    return name.contains(_query);
                  }).toList();
                  if (filtered.isEmpty) {
                    return const Center(child: Text('No logged scriptures match — log one from the Bible tab first.'));
                  }
                  return ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, i) {
                      final e = filtered[i];
                      final name = bookNameById[e.bookId] ?? 'Book ${e.bookId}';
                      final label = e.verseStart == e.verseEnd
                          ? '$name ${e.chapter}:${e.verseStart}'
                          : '$name ${e.chapter}:${e.verseStart}-${e.verseEnd}';
                      return ListTile(
                        title: Text(label),
                        subtitle: (e.verseText?.isNotEmpty ?? false)
                            ? Text(e.verseText!, maxLines: 1, overflow: TextOverflow.ellipsis)
                            : null,
                        onTap: () => Navigator.of(context).pop(e),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
