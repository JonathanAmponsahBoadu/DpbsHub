import 'dart:convert';

import 'package:http/http.dart' as http;

import 'ai_client.dart';
import 'base_ai_client.dart';

class GeminiClient extends BaseAiClient {
  GeminiClient(this.apiKey);
  final String apiKey;

  static const _model = 'gemini-3.6-flash';

  @override
  Future<String> complete(String prompt) async {
    final uri = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/$_model:generateContent?key=$apiKey',
    );
    final http.Response response;
    try {
      response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt},
              ],
            },
          ],
          'generationConfig': {'responseMimeType': 'application/json'},
        }),
      );
    } catch (e) {
      throw AiClientException('Could not reach Gemini — check your connection.');
    }

    if (response.statusCode == 401 || response.statusCode == 403) {
      throw AiClientException('Gemini rejected the API key — check it in Settings.');
    }
    if (response.statusCode == 429) {
      throw AiClientException('Gemini rate limit reached — try again shortly.');
    }
    if (response.statusCode != 200) {
      throw AiClientException('Gemini error (${response.statusCode}).');
    }

    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final candidates = body['candidates'] as List;
      final parts = (candidates.first as Map<String, dynamic>)['content']['parts'] as List;
      // The response may include a "thoughtSignature"-only part alongside
      // the actual text part; find the one that actually has text.
      for (final part in parts) {
        final text = (part as Map<String, dynamic>)['text'] as String?;
        if (text != null && text.isNotEmpty) return text;
      }
      throw AiClientException('Gemini returned an empty response.');
    } on AiClientException {
      rethrow;
    } catch (_) {
      throw AiClientException('Could not parse Gemini\'s response.');
    }
  }
}
