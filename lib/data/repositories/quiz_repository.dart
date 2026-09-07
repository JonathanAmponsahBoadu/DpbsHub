import 'dart:convert';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../local/database.dart';

/// One question presented in a quiz session, with everything needed to render
/// it and grade the answer.
class QuizQuestion {
  QuizQuestion({
    required this.prompt,
    required this.correctAnswer,
    this.choices = const [],
  });
  final String prompt;
  final String correctAnswer;

  /// Multiple-choice distractors + correct answer, pre-shuffled. Empty for
  /// free-text questions (e.g. text recall), where grading is fuzzy-matched.
  final List<String> choices;
}

enum QuizScopeType { book, chapter, verseRange, tag, talk }

enum QuizType { referenceRecall, textRecall, talkRecall }

class QuizRepository {
  QuizRepository(this._db);
  final AppDatabase _db;
  static const _uuid = Uuid();
  final _random = Random();

  /// Builds a question set from your own saved data for the chosen scope+type.
  /// Returns an empty list if you haven't logged enough material yet.
  Future<List<QuizQuestion>> buildQuiz({
    required QuizScopeType scopeType,
    required QuizType quizType,
    int? bookId,
    int? chapter,
    String? tagId,
    String? talkId,
  }) async {
    switch (quizType) {
      case QuizType.talkRecall:
        return _buildTalkRecallQuiz(talkId!);
      case QuizType.referenceRecall:
      case QuizType.textRecall:
        final entries = await _entriesForScope(
          scopeType: scopeType,
          bookId: bookId,
          chapter: chapter,
          tagId: tagId,
        );
        return quizType == QuizType.referenceRecall
            ? await _buildReferenceRecallQuiz(entries)
            : _buildTextRecallQuiz(entries);
    }
  }

  Future<List<StudyEntry>> _entriesForScope({
    required QuizScopeType scopeType,
    int? bookId,
    int? chapter,
    String? tagId,
  }) async {
    if (scopeType == QuizScopeType.tag && tagId != null) {
      final links = await (_db.select(_db.noteTagLinks)
            ..where((l) => l.tagId.equals(tagId)))
          .get();
      final entries = <StudyEntry>[];
      for (final link in links) {
        final note = await (_db.select(_db.studyNotes)
              ..where((n) => n.id.equals(link.noteId)))
            .getSingleOrNull();
        if (note?.studyEntryId != null) {
          final entry = await (_db.select(_db.studyEntries)
                ..where((e) => e.id.equals(note!.studyEntryId!)))
              .getSingleOrNull();
          if (entry != null) entries.add(entry);
        }
      }
      return entries;
    }

    final query = _db.select(_db.studyEntries);
    if (bookId != null) query.where((e) => e.bookId.equals(bookId));
    if (scopeType == QuizScopeType.chapter && chapter != null) {
      query.where((e) => e.chapter.equals(chapter));
    }
    return query.get();
  }

  Future<List<QuizQuestion>> _buildReferenceRecallQuiz(
      List<StudyEntry> entries) async {
    final withText = entries.where((e) => (e.verseText ?? '').trim().isNotEmpty).toList();
    final questions = <QuizQuestion>[];
    for (final entry in withText) {
      final book = await (_db.select(_db.books)
            ..where((b) => b.id.equals(entry.bookId)))
          .getSingle();
      final name = entry.language == 'tw' ? book.nameTw : book.nameEn;
      final ref = entry.verseStart == entry.verseEnd
          ? '$name ${entry.chapter}:${entry.verseStart}'
          : '$name ${entry.chapter}:${entry.verseStart}-${entry.verseEnd}';
      questions.add(QuizQuestion(prompt: entry.verseText!, correctAnswer: ref));
    }
    questions.shuffle(_random);

    // Multiple-choice needs at least 4 distinct references in the pool;
    // otherwise leave choices empty and the UI falls back to free-text entry.
    final allAnswers = questions.map((q) => q.correctAnswer).toSet().toList();
    if (allAnswers.length < 4) return questions;

    return questions.map((q) {
      final distractors = allAnswers.where((a) => a != q.correctAnswer).toList()
        ..shuffle(_random);
      final choices = [q.correctAnswer, ...distractors.take(3)]..shuffle(_random);
      return QuizQuestion(prompt: q.prompt, correctAnswer: q.correctAnswer, choices: choices);
    }).toList();
  }

  List<QuizQuestion> _buildTextRecallQuiz(List<StudyEntry> entries) {
    final withText = entries.where((e) => (e.verseText ?? '').trim().isNotEmpty).toList();
    final questions = withText.map((entry) {
      final ref = entry.verseStart == entry.verseEnd
          ? 'Chapter ${entry.chapter}, verse ${entry.verseStart}'
          : 'Chapter ${entry.chapter}, verses ${entry.verseStart}-${entry.verseEnd}';
      return QuizQuestion(prompt: ref, correctAnswer: entry.verseText!.trim());
    }).toList();
    questions.shuffle(_random);
    return questions;
  }

  Future<List<QuizQuestion>> _buildTalkRecallQuiz(String talkId) async {
    final points = await (_db.select(_db.talkPoints)
          ..where((p) => p.talkId.equals(talkId))
          ..orderBy([(p) => OrderingTerm.asc(p.orderIndex)]))
        .get();
    final questions = points.asMap().entries.map((e) {
      return QuizQuestion(
        prompt: 'What was outline point #${e.key + 1} of this talk?',
        correctAnswer: e.value.pointText,
      );
    }).toList();
    return questions;
  }

  /// Fuzzy grading for free-text answers: case/punctuation/whitespace-insensitive,
  /// tolerant of minor typos via normalized-edit-distance threshold.
  bool gradeAnswer(String userAnswer, String correctAnswer) {
    final a = _normalize(userAnswer);
    final b = _normalize(correctAnswer);
    if (a == b) return true;
    if (a.isEmpty) return false;
    final distance = _levenshtein(a, b);
    final threshold = (b.length * 0.15).ceil().clamp(1, 20);
    return distance <= threshold;
  }

  String _normalize(String s) => s
      .toLowerCase()
      .replaceAll(RegExp(r'[^\w\s]'), '')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();

  int _levenshtein(String a, String b) {
    final dp = List.generate(a.length + 1, (_) => List.filled(b.length + 1, 0));
    for (var i = 0; i <= a.length; i++) dp[i][0] = i;
    for (var j = 0; j <= b.length; j++) dp[0][j] = j;
    for (var i = 1; i <= a.length; i++) {
      for (var j = 1; j <= b.length; j++) {
        final cost = a[i - 1] == b[j - 1] ? 0 : 1;
        dp[i][j] = [
          dp[i - 1][j] + 1,
          dp[i][j - 1] + 1,
          dp[i - 1][j - 1] + cost,
        ].reduce(min);
      }
    }
    return dp[a.length][b.length];
  }

  Future<String> startSession({
    required QuizScopeType scopeType,
    required QuizType quizType,
    required Map<String, dynamic> scopeRef,
    required int totalQuestions,
  }) async {
    final id = _uuid.v4();
    await _db.into(_db.quizSessions).insert(QuizSessionsCompanion.insert(
          id: id,
          scopeType: scopeType.name,
          scopeRefJson: jsonEncode(scopeRef),
          quizType: quizType.name,
          startedAt: DateTime.now(),
          totalQuestions: Value(totalQuestions),
        ));
    return id;
  }

  Future<void> recordAttempt({
    required String sessionId,
    required QuizQuestion question,
    required String? userAnswer,
    required bool isCorrect,
  }) async {
    await _db.into(_db.quizAttempts).insert(QuizAttemptsCompanion.insert(
          id: _uuid.v4(),
          sessionId: sessionId,
          promptText: question.prompt,
          correctAnswer: question.correctAnswer,
          userAnswer: Value(userAnswer),
          isCorrect: Value(isCorrect),
        ));
  }

  Future<void> finishSession(String sessionId, int score) async {
    await (_db.update(_db.quizSessions)..where((s) => s.id.equals(sessionId)))
        .write(QuizSessionsCompanion(
      finishedAt: Value(DateTime.now()),
      score: Value(score),
    ));
  }

  Stream<List<QuizSession>> watchHistory() => (_db.select(_db.quizSessions)
        ..orderBy([(s) => OrderingTerm.desc(s.startedAt)]))
      .watch();
}
