import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../data/providers.dart';
import '../../data/repositories/quiz_repository.dart';

// --- Wizard selection state (scope -> type), transient UI state only ---
final selectedScopeTypeProvider = StateProvider<QuizScopeType?>((ref) => null);
final selectedBookIdProvider = StateProvider<int?>((ref) => null);
final selectedChapterProvider = StateProvider<int?>((ref) => null);
final selectedTagIdProvider = StateProvider<String?>((ref) => null);
final selectedTalkIdProvider = StateProvider<String?>((ref) => null);
final selectedQuizTypeProvider = StateProvider<QuizType?>((ref) => null);

class QuizAttemptRecord {
  QuizAttemptRecord({required this.question, required this.userAnswer, required this.isCorrect});
  final QuizQuestion question;
  final String? userAnswer;
  final bool isCorrect;
}

class ActiveQuizState {
  const ActiveQuizState({
    this.sessionId,
    this.questions = const [],
    this.currentIndex = 0,
    this.attempts = const [],
  });

  final String? sessionId;
  final List<QuizQuestion> questions;
  final int currentIndex;
  final List<QuizAttemptRecord> attempts;

  int get score => attempts.where((a) => a.isCorrect).length;
  bool get isFinished => currentIndex >= questions.length;
  QuizQuestion? get currentQuestion => isFinished ? null : questions[currentIndex];

  ActiveQuizState copyWith({
    String? sessionId,
    List<QuizQuestion>? questions,
    int? currentIndex,
    List<QuizAttemptRecord>? attempts,
  }) {
    return ActiveQuizState(
      sessionId: sessionId ?? this.sessionId,
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      attempts: attempts ?? this.attempts,
    );
  }
}

final activeQuizProvider =
    NotifierProvider<ActiveQuizNotifier, ActiveQuizState>(ActiveQuizNotifier.new);

class ActiveQuizNotifier extends Notifier<ActiveQuizState> {
  @override
  ActiveQuizState build() => const ActiveQuizState();

  Future<void> start({
    required QuizScopeType scopeType,
    required QuizType quizType,
    int? bookId,
    int? chapter,
    String? tagId,
    String? talkId,
  }) async {
    final repo = ref.read(quizRepositoryProvider);
    final questions = await repo.buildQuiz(
      scopeType: scopeType,
      quizType: quizType,
      bookId: bookId,
      chapter: chapter,
      tagId: tagId,
      talkId: talkId,
    );
    if (questions.isEmpty) {
      state = const ActiveQuizState();
      return;
    }
    final sessionId = await repo.startSession(
      scopeType: scopeType,
      quizType: quizType,
      scopeRef: {
        if (bookId != null) 'bookId': bookId,
        if (chapter != null) 'chapter': chapter,
        if (tagId != null) 'tagId': tagId,
        if (talkId != null) 'talkId': talkId,
      },
      totalQuestions: questions.length,
    );
    state = ActiveQuizState(sessionId: sessionId, questions: questions);
  }

  Future<void> submitAnswer(String? userAnswer) async {
    final question = state.currentQuestion;
    if (question == null || state.sessionId == null) return;
    final repo = ref.read(quizRepositoryProvider);

    bool isCorrect;
    if (userAnswer == null) {
      isCorrect = false;
    } else if (question.needsAiGrading) {
      // AI-evaluated: a second call judges the free-text answer against the
      // original note, rather than a local string match.
      final (_, client) = await ref.read(aiServiceProvider).activeClient();
      isCorrect = await client.gradeLessonAnswer(
        noteText: question.gradingNoteText ?? question.correctAnswer,
        question: question.prompt,
        userAnswer: userAnswer,
      );
    } else if (question.choices.isNotEmpty) {
      isCorrect = userAnswer == question.correctAnswer;
    } else {
      isCorrect = repo.gradeAnswer(userAnswer, question.correctAnswer);
    }

    await repo.recordAttempt(
      sessionId: state.sessionId!,
      question: question,
      userAnswer: userAnswer,
      isCorrect: isCorrect,
    );

    final attempts = [
      ...state.attempts,
      QuizAttemptRecord(question: question, userAnswer: userAnswer, isCorrect: isCorrect),
    ];
    state = state.copyWith(attempts: attempts, currentIndex: state.currentIndex + 1);

    if (state.isFinished) {
      await repo.finishSession(state.sessionId!, state.score);
    }
  }

  void reset() => state = const ActiveQuizState();
}
