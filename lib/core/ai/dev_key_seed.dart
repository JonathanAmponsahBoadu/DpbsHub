import 'package:flutter/foundation.dart';

import '../security/api_key_vault.dart';
import 'ai_provider.dart';

/// Debug-build-only convenience: if `.env` was supplied via
/// `flutter run --dart-define-from-file=.env` (see .env.example) and the
/// on-device vault doesn't already have a key for a provider, seed it —
/// so reinstalling during development doesn't mean retyping keys into the
/// app every time. Compiles to a no-op in release builds regardless of
/// whether dart-define values were passed, since [kDebugMode] is false there.
Future<void> seedDevApiKeysIfPresent(ApiKeyVault vault) async {
  if (!kDebugMode) return;

  const gemini = String.fromEnvironment('GEMINI_API_KEY');
  const groq = String.fromEnvironment('GROQ_API_KEY');

  if (gemini.isNotEmpty && await vault.getKey(AiProvider.gemini) == null) {
    await vault.setKey(AiProvider.gemini, gemini);
  }
  if (groq.isNotEmpty && await vault.getKey(AiProvider.groq) == null) {
    await vault.setKey(AiProvider.groq, groq);
  }
  if (await vault.getActiveProvider() == null) {
    if (gemini.isNotEmpty) {
      await vault.setActiveProvider(AiProvider.gemini);
    } else if (groq.isNotEmpty) {
      await vault.setActiveProvider(AiProvider.groq);
    }
  }
}
