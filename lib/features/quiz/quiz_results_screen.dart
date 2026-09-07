import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../shared/widgets/gradient_surface.dart';
import 'quiz_state.dart';

class QuizResultsScreen extends ConsumerWidget {
  const QuizResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quiz = ref.watch(activeQuizProvider);
    final total = quiz.questions.length;
    final score = quiz.score;
    final pct = total == 0 ? 0 : ((score / total) * 100).round();

    return Scaffold(
      appBar: AppBar(title: const Text('Results'), automaticallyImplyLeading: false),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          GradientSurface(
            child: Column(
              children: [
                Text(
                  pct >= 80 ? '🎉' : (pct >= 50 ? '💪' : '📖'),
                  style: const TextStyle(fontSize: 40),
                ),
                const SizedBox(height: 8),
                Text('$score / $total',
                    style: const TextStyle(
                        color: Colors.white, fontSize: 34, fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                Text('$pct% correct',
                    style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          for (final attempt in quiz.attempts)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: Icon(
                  attempt.isCorrect ? Icons.check_circle : Icons.cancel,
                  color: attempt.isCorrect ? Colors.green : Colors.redAccent,
                ),
                title: Text(attempt.question.prompt, maxLines: 2, overflow: TextOverflow.ellipsis),
                subtitle: Text(
                  attempt.isCorrect
                      ? 'Correct: ${attempt.question.correctAnswer}'
                      : 'You said: ${attempt.userAnswer ?? "(skipped)"}\nCorrect: ${attempt.question.correctAnswer}',
                ),
              ),
            ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () {
              ref.read(activeQuizProvider.notifier).reset();
              ref.read(selectedScopeTypeProvider.notifier).state = null;
              ref.read(selectedQuizTypeProvider.notifier).state = null;
              context.go('/quiz');
            },
            child: const Text('Quiz again'),
          ),
        ],
      ),
    );
  }
}
