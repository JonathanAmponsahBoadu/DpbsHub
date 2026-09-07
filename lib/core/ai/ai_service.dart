import '../security/api_key_vault.dart';
import 'ai_client.dart';
import 'ai_provider.dart';
import 'gemini_client.dart';
import 'groq_client.dart';

/// Resolves the currently-active provider + its stored key into a ready
/// [AiClient], so the quiz layer never touches the vault or provider
/// selection directly.
class AiService {
  AiService(this._vault);
  final ApiKeyVault _vault;

  Future<AiProvider?> activeProvider() => _vault.getActiveProvider();

  Future<AiClient> _clientFor(AiProvider provider) async {
    final key = await _vault.getKey(provider);
    if (key == null || key.isEmpty) {
      throw AiClientException(
        '${provider.displayName} has no API key saved yet — add one in Settings → AI Providers.',
      );
    }
    return switch (provider) {
      AiProvider.gemini => GeminiClient(key),
      AiProvider.groq => GroqClient(key),
    };
  }

  /// The client for whichever provider is currently active. Throws
  /// [AiClientException] if none is configured yet.
  Future<(AiProvider, AiClient)> activeClient() async {
    final provider = await activeProvider();
    if (provider == null) {
      throw AiClientException('No AI provider selected yet — set one up in Settings → AI Providers.');
    }
    return (provider, await _clientFor(provider));
  }
}
