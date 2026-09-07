import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../ai/ai_provider.dart';

/// Stores AI provider API keys in Android Keystore-backed encrypted storage
/// (via flutter_secure_storage) — never in the Drift database, never synced,
/// never logged. The UI that reads/writes through this (Settings → AI
/// Providers) is gated behind [BiometricGate]; this class itself has no
/// gate of its own, since it's also used internally by [AiService] to fetch
/// the active key for a request without re-prompting on every quiz question.
class ApiKeyVault {
  ApiKeyVault._();
  static final instance = ApiKeyVault._();

  // v11's default AndroidOptions already uses AES-GCM + Keystore-wrapped
  // keys — no extra flags needed for strong encryption at rest.
  static const _storage = FlutterSecureStorage(aOptions: AndroidOptions());

  static const _activeProviderKey = 'active_ai_provider';

  String _keyName(AiProvider p) => 'ai_key_${p.name}';

  Future<String?> getKey(AiProvider provider) => _storage.read(key: _keyName(provider));

  Future<void> setKey(AiProvider provider, String value) =>
      _storage.write(key: _keyName(provider), value: value);

  Future<void> deleteKey(AiProvider provider) => _storage.delete(key: _keyName(provider));

  Future<Map<AiProvider, bool>> configuredProviders() async {
    final result = <AiProvider, bool>{};
    for (final p in AiProvider.values) {
      final key = await getKey(p);
      result[p] = key != null && key.isNotEmpty;
    }
    return result;
  }

  Future<AiProvider?> getActiveProvider() async {
    final raw = await _storage.read(key: _activeProviderKey);
    if (raw == null) return null;
    return AiProvider.values.where((p) => p.name == raw).firstOrNull;
  }

  Future<void> setActiveProvider(AiProvider provider) =>
      _storage.write(key: _activeProviderKey, value: provider.name);
}
