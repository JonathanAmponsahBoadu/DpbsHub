import 'dart:convert';

import 'package:http/http.dart' as http;

import 'ai_client.dart';
import 'base_ai_client.dart';

class GroqClient extends BaseAiClient {
  GroqClient(this.apiKey);
  final String apiKey;

  static const _model = 'openai/gpt-oss-120b';

  @override
  Future<String> complete(String prompt) async {
    final uri = Uri.parse('https://api.groq.com/openai/v1/chat/completions');
    final http.Response response;
    try {
      response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': _model,
          'messages': [
            {'role': 'user', 'content': prompt},
          ],
          'response_format': {'type': 'json_object'},
        }),
      );
    } catch (e) {
      throw AiClientException('Could not reach Groq — check your connection.');
    }

    if (response.statusCode == 401) {
      throw AiClientException('Groq rejected the API key — check it in Settings.');
    }
    if (response.statusCode == 429) {
      throw AiClientException('Groq rate limit reached — try again shortly.');
    }
    if (response.statusCode != 200) {
      throw AiClientException('Groq error (${response.statusCode}).');
    }

    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final choices = body['choices'] as List;
      final content = (choices.first as Map<String, dynamic>)['message']['content'] as String;
      return content;
    } catch (_) {
      throw AiClientException('Could not parse Groq\'s response.');
    }
  }
}
