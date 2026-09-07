import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'quiz_state.dart';

class QuizSessionScreen extends ConsumerStatefulWidget {
  const QuizSessionScreen({super.key});

  @override
  ConsumerState<QuizSessionScreen> createState() => _QuizSessionScreenState();
}

class _QuizSessionScreenState extends ConsumerState<QuizSessionScreen> {
  final _answerCtrl = TextEditingController();
  String? _selectedChoice;
  bool _submitting = false;

  @override
  Widget build(BuildContext context) {
    final quiz = ref.watch(activeQuizProvider);
    final question = quiz.currentQuestion;

    if (question == null) {
      // Finished (or never started) — bounce to results.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.pushReplacement('/quiz/results');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final progress = quiz.currentIndex / quiz.questions.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${quiz.currentIndex + 1} of ${quiz.questions.length}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(value: progress),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(question.prompt, style: Theme.of(context).textTheme.titleLarge),
              ),
            ),
            const SizedBox(height: 24),
            if (question.choices.isNotEmpty)
              for (final choice in question.choices)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: RadioListTile<String>(
                    value: choice,
                    groupValue: _selectedChoice,
                    onChanged: (v) => setState(() => _selectedChoice = v),
                    title: Text(choice),
                    tileColor: Theme.of(context).colorScheme.surfaceContainerHigh,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                )
            else
              TextField(
                controller: _answerCtrl,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Your answer'),
              ),
            const Spacer(),
            FilledButton(
              onPressed: _submitting ? null : _submit,
              child: _submitting
                  ? const SizedBox(
                      height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(quiz.currentIndex == quiz.questions.length - 1
                      ? 'Finish'
                      : 'Next question'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    setState(() => _submitting = true);
    final question = ref.read(activeQuizProvider).currentQuestion!;
    final answer = question.choices.isNotEmpty ? _selectedChoice : _answerCtrl.text.trim();
    await ref.read(activeQuizProvider.notifier).submitAnswer(answer);
    _answerCtrl.clear();
    setState(() {
      _selectedChoice = null;
      _submitting = false;
    });
  }
}
