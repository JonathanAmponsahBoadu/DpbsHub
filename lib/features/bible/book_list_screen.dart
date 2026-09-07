import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/bible_urls.dart';
import '../../core/theme/app_theme.dart';
import '../../data/local/database.dart';
import '../../data/providers.dart';
import '../../shared/widgets/glass_gold_tile.dart';
import '../../shared/widgets/jw_org_link_button.dart';

class BookListScreen extends ConsumerWidget {
  const BookListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksAsync = ref.watch(_booksStreamProvider);
    final lang = ref.watch(studyLanguageProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bible'),
        actions: [
          JwOrgLinkButton(url: buildJwOrgLibraryLink(language: lang), compact: true),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: _LangToggle(lang: lang, ref: ref),
          ),
        ],
      ),
      body: booksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Failed to load books: $e')),
        data: (books) {
          final hebrew = books.where((b) => b.testament == 'hebrew').toList();
          final greek = books.where((b) => b.testament == 'greek').toList();
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              _SectionHeader(
                  title: 'Hebrew-Aramaic Scriptures', count: hebrew.length, color: AppTheme.emerald),
              const SizedBox(height: 10),
              _BookGrid(books: hebrew, lang: lang, dotColor: AppTheme.emerald),
              const SizedBox(height: 24),
              _SectionHeader(
                  title: 'Christian Greek Scriptures', count: greek.length, color: AppTheme.sky),
              const SizedBox(height: 10),
              _BookGrid(books: greek, lang: lang, dotColor: AppTheme.sky),
            ],
          );
        },
      ),
    );
  }
}

final _booksStreamProvider = StreamProvider<List<Book>>((ref) {
  return ref.watch(bibleRepositoryProvider).watchBooks();
});

class _LangToggle extends StatelessWidget {
  const _LangToggle({required this.lang, required this.ref});
  final String lang;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          _LangPill(label: 'EN', selected: lang == 'en', onTap: () => _set(ref, 'en')),
          _LangPill(label: 'TW', selected: lang == 'tw', onTap: () => _set(ref, 'tw')),
        ],
      ),
    );
  }

  void _set(WidgetRef ref, String v) => ref.read(studyLanguageProvider.notifier).state = v;
}

class _LangPill extends StatelessWidget {
  const _LangPill({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? scheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 12,
            color: selected ? scheme.onPrimary : scheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.count, required this.color});
  final String title;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 6, height: 22, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            '$title  ·  $count books',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }
}

class _BookGrid extends StatelessWidget {
  const _BookGrid({required this.books, required this.lang, required this.dotColor});
  final List<Book> books;
  final String lang;
  final Color dotColor;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: books.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, i) {
        final book = books[i];
        final fullName = lang == 'tw' ? book.nameTw : book.nameEn;
        final abbr = lang == 'tw' ? book.abbrTw : book.abbrEn;
        return Tooltip(
          message: fullName,
          child: GlassGoldTile(
            onTap: () => context.push('/bible/book/${book.id}'),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
                  ),
                  const SizedBox(height: 6),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      abbr.isEmpty ? fullName : abbr,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
