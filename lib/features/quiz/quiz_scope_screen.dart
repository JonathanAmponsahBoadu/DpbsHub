import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/local/database.dart';
import '../../data/providers.dart';
import '../../data/repositories/quiz_repository.dart';
import 'quiz_state.dart';

final _booksProvider = StreamProvider((ref) => ref.watch(bibleRepositoryProvider).watchBooks());
final _tagsProvider = StreamProvider((ref) => ref.watch(notesRepositoryProvider).watchTags());
final _talksProvider = StreamProvider((ref) => ref.watch(talksRepositoryProvider).watchTalks());

class QuizScopeScreen extends ConsumerWidget {
  const QuizScopeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scopeType = ref.watch(selectedScopeTypeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Quiz — choose scope')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('What do you want to be quizzed on?',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final t in QuizScopeType.values)
                ChoiceChip(
                  label: Text(_scopeLabel(t)),
                  selected: scopeType == t,
                  onSelected: (_) {
                    ref.read(selectedScopeTypeProvider.notifier).state = t;
                    ref.read(selectedBookIdProvider.notifier).state = null;
                    ref.read(selectedChapterProvider.notifier).state = null;
                    ref.read(selectedTagIdProvider.notifier).state = null;
                    ref.read(selectedTalkIdProvider.notifier).state = null;
                  },
                ),
            ],
          ),
          const SizedBox(height: 24),
          if (scopeType == QuizScopeType.book || scopeType == QuizScopeType.chapter)
            _BookPicker(needsChapter: scopeType == QuizScopeType.chapter),
          if (scopeType == QuizScopeType.tag) const _TagPicker(),
          if (scopeType == QuizScopeType.talk) const _TalkPicker(),
          const SizedBox(height: 32),
          FilledButton(
            onPressed: _canProceed(ref, scopeType) ? () => context.push('/quiz/type') : null,
            child: const Text('Next: choose quiz type'),
          ),
        ],
      ),
    );
  }

  String _scopeLabel(QuizScopeType t) => switch (t) {
        QuizScopeType.book => 'A book',
        QuizScopeType.chapter => 'A chapter',
        QuizScopeType.verseRange => 'A verse range',
        QuizScopeType.tag => 'A tag',
        QuizScopeType.talk => 'A talk',
      };

  bool _canProceed(WidgetRef ref, QuizScopeType? scopeType) {
    switch (scopeType) {
      case null:
        return false;
      case QuizScopeType.book:
        return ref.watch(selectedBookIdProvider) != null;
      case QuizScopeType.chapter:
      case QuizScopeType.verseRange:
        return ref.watch(selectedBookIdProvider) != null &&
            ref.watch(selectedChapterProvider) != null;
      case QuizScopeType.tag:
        return ref.watch(selectedTagIdProvider) != null;
      case QuizScopeType.talk:
        return ref.watch(selectedTalkIdProvider) != null;
    }
  }
}

class _BookPicker extends ConsumerWidget {
  const _BookPicker({required this.needsChapter});
  final bool needsChapter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksAsync = ref.watch(_booksProvider);
    final bookId = ref.watch(selectedBookIdProvider);
    final lang = ref.watch(studyLanguageProvider);

    return booksAsync.when(
      loading: () => const CircularProgressIndicator(),
      error: (e, st) => Text('$e'),
      data: (books) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButtonFormField<int>(
            initialValue: bookId,
            decoration: const InputDecoration(labelText: 'Book'),
            items: [
              for (final b in books)
                DropdownMenuItem(value: b.id, child: Text(lang == 'tw' ? b.nameTw : b.nameEn)),
            ],
            onChanged: (v) => ref.read(selectedBookIdProvider.notifier).state = v,
          ),
          if (needsChapter && bookId != null) ...[
            const SizedBox(height: 12),
            _ChapterField(bookId: bookId, books: books),
          ],
        ],
      ),
    );
  }
}

class _ChapterField extends ConsumerWidget {
  const _ChapterField({required this.bookId, required this.books});
  final int bookId;
  final List<Book> books;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final book = books.firstWhere((b) => b.id == bookId);
    final chapter = ref.watch(selectedChapterProvider);
    return DropdownButtonFormField<int>(
      initialValue: chapter,
      decoration: const InputDecoration(labelText: 'Chapter'),
      items: [
        for (var c = 1; c <= book.chapterCount; c++)
          DropdownMenuItem(value: c, child: Text('Chapter $c')),
      ],
      onChanged: (v) => ref.read(selectedChapterProvider.notifier).state = v,
    );
  }
}

class _TagPicker extends ConsumerWidget {
  const _TagPicker();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tagsAsync = ref.watch(_tagsProvider);
    final tagId = ref.watch(selectedTagIdProvider);
    return tagsAsync.when(
      loading: () => const CircularProgressIndicator(),
      error: (e, st) => Text('$e'),
      data: (tags) => tags.isEmpty
          ? const Text('No tags yet — add tags while logging scriptures first.')
          : Wrap(
              spacing: 8,
              children: [
                for (final t in tags)
                  ChoiceChip(
                    label: Text(t.name),
                    selected: tagId == t.id,
                    onSelected: (_) => ref.read(selectedTagIdProvider.notifier).state = t.id,
                  ),
              ],
            ),
    );
  }
}

class _TalkPicker extends ConsumerWidget {
  const _TalkPicker();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final talksAsync = ref.watch(_talksProvider);
    final talkId = ref.watch(selectedTalkIdProvider);
    return talksAsync.when(
      loading: () => const CircularProgressIndicator(),
      error: (e, st) => Text('$e'),
      data: (talks) => talks.isEmpty
          ? const Text('No talks logged yet — add one from the Talks tab first.')
          : DropdownButtonFormField<String>(
              initialValue: talkId,
              decoration: const InputDecoration(labelText: 'Talk'),
              items: [
                for (final t in talks) DropdownMenuItem(value: t.id, child: Text(t.title)),
              ],
              onChanged: (v) => ref.read(selectedTalkIdProvider.notifier).state = v,
            ),
    );
  }
}
