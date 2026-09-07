import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/bible_urls.dart';
import '../../data/local/database.dart';
import '../../data/providers.dart';
import '../../shared/widgets/glass_gold_tile.dart';
import '../../shared/widgets/jw_org_link_button.dart';

final _bookProvider = FutureProvider.family<Book, int>((ref, bookId) {
  return ref.watch(bibleRepositoryProvider).bookById(bookId);
});

final _studiedChaptersProvider = StreamProvider.family<Set<int>, int>((ref, bookId) {
  return ref.watch(bibleRepositoryProvider).watchStudiedChapters(bookId);
});

class ChapterGridScreen extends ConsumerWidget {
  const ChapterGridScreen({super.key, required this.bookId});
  final int bookId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookAsync = ref.watch(_bookProvider(bookId));
    final studied = ref.watch(_studiedChaptersProvider(bookId)).value ?? <int>{};
    final lang = ref.watch(studyLanguageProvider);

    return Scaffold(
      appBar: AppBar(
        title: bookAsync.when(
          data: (b) => Text(lang == 'tw' ? b.nameTw : b.nameEn),
          loading: () => const Text(''),
          error: (_, __) => const Text('Bible'),
        ),
        actions: [
          bookAsync.maybeWhen(
            data: (book) => JwOrgLinkButton(
              url: buildJwOrgBookLink(book, language: lang),
              compact: true,
            ),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: bookAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('$e')),
        data: (book) => Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
            itemCount: book.chapterCount,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, i) {
              final chapter = i + 1;
              final hasEntries = studied.contains(chapter);
              return _ChapterCell(
                chapter: chapter,
                hasEntries: hasEntries,
                onTap: () => context.push('/bible/book/$bookId/chapter/$chapter'),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ChapterCell extends StatelessWidget {
  const _ChapterCell({required this.chapter, required this.hasEntries, required this.onTap});
  final int chapter;
  final bool hasEntries;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GlassGoldTile(
      muted: !hasEntries,
      borderRadius: 14,
      onTap: onTap,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$chapter', style: const TextStyle(fontWeight: FontWeight.w800)),
            if (hasEntries) ...[
              const SizedBox(height: 2),
              const Icon(Icons.check_circle, size: 12),
            ],
          ],
        ),
      ),
    );
  }
}
