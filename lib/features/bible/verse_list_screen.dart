import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../core/constants/bible_urls.dart';
import '../../data/assets_source/verse_counts.dart';
import '../../data/local/database.dart';
import '../../data/providers.dart';
import '../../shared/widgets/glass_gold_tile.dart';
import '../../shared/widgets/jw_org_link_button.dart';
import 'verse_entry_sheet.dart';

final _bookProvider = FutureProvider.family<Book, int>((ref, bookId) {
  return ref.watch(bibleRepositoryProvider).bookById(bookId);
});

final _entriesProvider =
    StreamProvider.family<List<StudyEntry>, (int, int)>((ref, key) {
  return ref.watch(bibleRepositoryProvider).watchEntriesForChapter(key.$1, key.$2);
});

/// true = verse skeleton grid (default, when the chapter's verse count is
/// known), false = raw list of only what you've logged.
final _gridViewProvider = StateProvider<bool>((ref) => true);

class VerseListScreen extends ConsumerWidget {
  const VerseListScreen({super.key, required this.bookId, required this.chapter});
  final int bookId;
  final int chapter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookAsync = ref.watch(_bookProvider(bookId));
    final entriesAsync = ref.watch(_entriesProvider((bookId, chapter)));
    final lang = ref.watch(studyLanguageProvider);
    final maxVerse = verseCountFor(bookId, chapter);
    final showGrid = maxVerse != null && ref.watch(_gridViewProvider);

    return Scaffold(
      appBar: AppBar(
        title: bookAsync.when(
          data: (b) => Text('${lang == 'tw' ? b.nameTw : b.nameEn} $chapter'),
          loading: () => const Text(''),
          error: (_, st) => const Text('Bible'),
        ),
        actions: [
          if (maxVerse != null)
            IconButton(
              tooltip: showGrid ? 'Switch to list view' : 'Switch to verse grid',
              icon: Icon(showGrid ? Icons.view_list : Icons.grid_view),
              onPressed: () =>
                  ref.read(_gridViewProvider.notifier).state = !ref.read(_gridViewProvider),
            ),
          bookAsync.maybeWhen(
            data: (book) => JwOrgLinkButton(
              url: buildJwOrgLink(book, chapter, language: lang),
              compact: true,
            ),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showVerseEntrySheet(context, bookId: bookId, chapter: chapter),
        icon: const Icon(Icons.add),
        label: const Text('Add verse(s)'),
      ),
      body: entriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('$e')),
        data: (entries) {
          if (showGrid) {
            return _VerseGrid(
              bookId: bookId,
              chapter: chapter,
              maxVerse: maxVerse,
              entries: entries,
            );
          }
          return _VerseRawList(bookId: bookId, chapter: chapter, entries: entries);
        },
      ),
    );
  }
}

class _VerseGrid extends StatelessWidget {
  const _VerseGrid({
    required this.bookId,
    required this.chapter,
    required this.maxVerse,
    required this.entries,
  });
  final int bookId;
  final int chapter;
  final int maxVerse;
  final List<StudyEntry> entries;

  StudyEntry? _entryCovering(int verse) {
    for (final e in entries) {
      if (verse >= e.verseStart && verse <= e.verseEnd) return e;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      itemCount: maxVerse,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, i) {
        final verse = i + 1;
        final entry = _entryCovering(verse);
        return GlassGoldTile(
          muted: entry == null,
          borderRadius: 12,
          onTap: () => entry != null
              ? showVerseEntrySheet(context, bookId: bookId, chapter: chapter, existing: entry)
              : showVerseEntrySheet(context, bookId: bookId, chapter: chapter, initialVerse: verse),
          child: Center(
            child: Text('$verse', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
          ),
        );
      },
    );
  }
}

class _VerseRawList extends ConsumerWidget {
  const _VerseRawList({required this.bookId, required this.chapter, required this.entries});
  final int bookId;
  final int chapter;
  final List<StudyEntry> entries;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookAsync = ref.watch(_bookProvider(bookId));
    final lang = ref.watch(studyLanguageProvider);

    if (entries.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.menu_book_outlined, size: 48, color: Theme.of(context).colorScheme.outline),
              const SizedBox(height: 12),
              Text(
                'Nothing logged for this chapter yet.\nTap "Read on jw.org" above to read it, then add what you studied.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      itemCount: entries.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final e = entries[i];
        final label = e.verseStart == e.verseEnd
            ? 'Verse ${e.verseStart}'
            : 'Verses ${e.verseStart}-${e.verseEnd}';
        return Card(
          child: ListTile(
            onTap: () => showVerseEntrySheet(context, bookId: bookId, chapter: chapter, existing: e),
            title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(
              (e.verseText?.isNotEmpty ?? false) ? e.verseText! : '(no text saved yet)',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                bookAsync.maybeWhen(
                  data: (book) => JwOrgLinkButton(
                    url: buildJwOrgLink(book, chapter, verse: e.verseStart, language: lang),
                    compact: true,
                  ),
                  orElse: () => const SizedBox.shrink(),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => ref.read(bibleRepositoryProvider).deleteEntry(e.id),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
