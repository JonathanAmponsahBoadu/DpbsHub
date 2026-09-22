import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/assets_source/verse_counts.dart';
import '../../data/local/database.dart';
import '../../data/providers.dart';
import '../../data/repositories/attachments_repository.dart';
import '../../shared/widgets/attachments_strip.dart';

/// Bottom sheet to add (or edit) a studied verse/range: the verse text you
/// personally typed/pasted in, plus an optional note and tags — all in one
/// pass, since that's the natural rhythm of logging a study session.
Future<void> showVerseEntrySheet(
  BuildContext context, {
  required int bookId,
  required int chapter,
  StudyEntry? existing,
  int? initialVerse,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => _VerseEntrySheet(
      bookId: bookId,
      chapter: chapter,
      existing: existing,
      initialVerse: initialVerse,
    ),
  );
}

class _VerseEntrySheet extends ConsumerStatefulWidget {
  const _VerseEntrySheet({
    required this.bookId,
    required this.chapter,
    this.existing,
    this.initialVerse,
  });
  final int bookId;
  final int chapter;
  final StudyEntry? existing;
  final int? initialVerse;

  @override
  ConsumerState<_VerseEntrySheet> createState() => _VerseEntrySheetState();
}

class _VerseEntrySheetState extends ConsumerState<_VerseEntrySheet> {
  late final _verseStartCtrl = TextEditingController(
      text: widget.existing?.verseStart.toString() ?? widget.initialVerse?.toString() ?? '');
  late final _verseEndCtrl = TextEditingController(
      text: widget.existing?.verseEnd.toString() ?? widget.initialVerse?.toString() ?? '');
  late final _textCtrl = TextEditingController(text: widget.existing?.verseText ?? '');
  final _noteCtrl = TextEditingController();
  final _newTagCtrl = TextEditingController();
  final Set<String> _selectedTagIds = {};
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(studyLanguageProvider);
    final tagsAsync = ref.watch(_tagsProvider);

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
              widget.existing == null ? 'Add studied verse(s)' : 'Edit entry',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              'Language: ${lang == 'tw' ? 'Twi' : 'English'} — Chapter ${widget.chapter}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _verseStartCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Verse start'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _verseEndCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Verse end (optional)'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _textCtrl,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Verse text (type/paste from your NWT)',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _noteCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Study note (optional) — what you learned',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 12),
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
                ownerType: AttachmentOwner.studyEntry,
                ownerId: widget.existing!.id,
              )
            else
              Text(
                'Save this entry first, then reopen it to attach a photo, video or voice note.',
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
                  : const Text('Save'),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    final start = int.tryParse(_verseStartCtrl.text.trim());
    if (start == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Enter a valid verse number')));
      return;
    }
    final end = int.tryParse(_verseEndCtrl.text.trim()) ?? start;
    if (end < start) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Verse end must be ≥ verse start')));
      return;
    }

    final maxVerse = verseCountFor(widget.bookId, widget.chapter);
    if (maxVerse != null && end > maxVerse) {
      final proceed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Verse may not exist'),
          content: Text(
            'Chapter ${widget.chapter} is recorded as having $maxVerse verses — '
            'verse $end would be beyond that. Continue anyway?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Add anyway'),
            ),
          ],
        ),
      );
      if (proceed != true) return;
    }

    setState(() => _saving = true);
    final lang = ref.read(studyLanguageProvider);
    final bibleRepo = ref.read(bibleRepositoryProvider);
    final notesRepo = ref.read(notesRepositoryProvider);

    final entry = await bibleRepo.addOrUpdateEntry(
      id: widget.existing?.id,
      bookId: widget.bookId,
      chapter: widget.chapter,
      verseStart: start,
      verseEnd: end,
      language: lang,
      verseText: _textCtrl.text.trim().isEmpty ? null : _textCtrl.text.trim(),
    );

    if (_noteCtrl.text.trim().isNotEmpty || _selectedTagIds.isNotEmpty) {
      await notesRepo.addNote(
        noteText: _noteCtrl.text.trim().isEmpty ? '(tagged, no note text)' : _noteCtrl.text.trim(),
        source: 'personalStudy',
        studyEntryId: entry.id,
        tagIds: _selectedTagIds.toList(),
      );
    }

    await ref.read(studyActivityServiceProvider).recordActivity();
    if (mounted) Navigator.of(context).pop();
  }
}

final _tagsProvider = StreamProvider((ref) => ref.watch(notesRepositoryProvider).watchTags());
