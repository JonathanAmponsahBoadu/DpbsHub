import 'dart:convert';

import 'ai_client.dart';

/// Shared prompt-building and JSON-parsing logic for both providers — only
/// the actual HTTP call ([complete]) differs between Gemini and Groq.
abstract class BaseAiClient implements AiClient {
  /// Sends [prompt] to the provider and returns its raw text reply (expected
  /// to be a single JSON object, since every prompt here asks for one).
  /// Throws [AiClientException] on any failure.
  Future<String> complete(String prompt);

  @override
  Future<TriviaQuestion> generateTrivia() async {
    final raw = await complete(
      'Generate one multiple-choice trivia question about Bible characters, '
      'events, or facts — suitable for a Jehovah\'s Witness Bible student '
      'reviewing what they know. Avoid obscure or disputed details. '
      'Respond with strict JSON only, no markdown, in exactly this shape: '
      '{"question": "...", "choices": ["...", "...", "...", "..."], "correctIndex": 0}. '
      'choices must have exactly 4 entries and correctIndex is the 0-based index of the right one.',
    );
    final json = _decode(raw);
    final choices = (json['choices'] as List).map((e) => e.toString()).toList();
    if (choices.length != 4) {
      throw AiClientException('Provider returned an unexpected number of choices.');
    }
    return TriviaQuestion(
      question: json['question'].toString(),
      choices: choices,
      correctIndex: json['correctIndex'] as int,
    );
  }

  @override
  Future<String> generateLessonQuestion(String noteText) async {
    final raw = await complete(
      'A Bible student wrote this personal study note:\n"$noteText"\n\n'
      'Write ONE short question that tests whether they still remember the lesson or point '
      'behind this note, without giving the answer away. Respond with strict JSON only: '
      '{"question": "..."}',
    );
    final json = _decode(raw);
    return json['question'].toString();
  }

  @override
  Future<bool> gradeLessonAnswer({
    required String noteText,
    required String question,
    required String userAnswer,
  }) async {
    final raw = await complete(
      'Original study note: "$noteText"\n'
      'Question asked: "$question"\n'
      'Student\'s answer: "$userAnswer"\n\n'
      'Judge whether the student\'s answer reasonably captures the lesson/point from the '
      'original note — be lenient about wording, strict about the actual idea. '
      'Respond with strict JSON only: {"correct": true or false}',
    );
    final json = _decode(raw);
    return json['correct'] == true;
  }

  Map<String, dynamic> _decode(String raw) {
    try {
      // Some models wrap JSON in markdown fences despite instructions; strip if present.
      final cleaned = raw.trim().replaceAll(RegExp(r'^```(json)?|```$'), '').trim();
      return jsonDecode(cleaned) as Map<String, dynamic>;
    } catch (_) {
      throw AiClientException('Could not understand the AI\'s response — try again.');
    }
  }
}
