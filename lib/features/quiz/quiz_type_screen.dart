import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/repositories/quiz_repository.dart';
import 'quiz_state.dart';

class QuizTypeScreen extends ConsumerStatefulWidget {
  const QuizTypeScreen({super.key});

  @override
  ConsumerState<QuizTypeScreen> createState() => _QuizTypeScreenState();
}

class _QuizTypeScreenState extends ConsumerState<QuizTypeScreen> {
  bool _starting = false;

  @override
  Widget build(BuildContext context) {
    final scopeType = ref.watch(selectedScopeTypeProvider)!;
    final quizType = ref.watch(selectedQuizTypeProvider);
    final availableTypes = scopeType == QuizScopeType.talk
        ? [QuizType.talkRecall]
        : [QuizType.referenceRecall, QuizType.textRecall];

    return Scaffold(
      appBar: AppBar(title: const Text('Quiz — choose type')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          for (final t in availableTypes)
            Card(
              child: RadioListTile<QuizType>(
                value: t,
                groupValue: quizType,
                onChanged: (v) => ref.read(selectedQuizTypeProvider.notifier).state = v,
                title: Text(_title(t)),
                subtitle: Text(_subtitle(t)),
              ),
            ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: quizType == null || _starting ? null : _start,
            child: _starting
                ? const SizedBox(
                    height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Start quiz'),
          ),
        ],
      ),
    );
  }

  String _title(QuizType t) => switch (t) {
        QuizType.referenceRecall => 'Where is this from?',
        QuizType.textRecall => 'What does it say?',
        QuizType.talkRecall => 'Recall the talk points',
      };

  String _subtitle(QuizType t) => switch (t) {
        QuizType.referenceRecall =>
          'Shown a verse\'s text, name the book/chapter/verse — tests precise reference recall.',
        QuizType.textRecall => 'Shown a reference, recall the verse text you saved.',
        QuizType.talkRecall => 'Recall the outline points you logged for this talk.',
      };

  Future<void> _start() async {
    setState(() => _starting = true);
    await ref.read(activeQuizProvider.notifier).start(
          scopeType: ref.read(selectedScopeTypeProvider)!,
          quizType: ref.read(selectedQuizTypeProvider)!,
          bookId: ref.read(selectedBookIdProvider),
          chapter: ref.read(selectedChapterProvider),
          tagId: ref.read(selectedTagIdProvider),
          talkId: ref.read(selectedTalkIdProvider),
        );
    if (!mounted) return;
    setState(() => _starting = false);
    final state = ref.read(activeQuizProvider);
    if (state.questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Not enough saved data for this scope yet — log more verses/notes first.'),
      ));
      return;
    }
    if (mounted) context.push('/quiz/session');
  }
}
