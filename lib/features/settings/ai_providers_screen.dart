import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/ai/ai_provider.dart';
import '../../core/security/biometric_gate.dart';
import '../../data/providers.dart';

/// Settings screen for managing AI provider API keys — gated behind
/// fingerprint/face (or device PIN as fallback) before anything here is
/// shown, since a key is a live credential. The active provider is always
/// switchable here and shown on-screen during a quiz.
class AiProvidersScreen extends StatefulWidget {
  const AiProvidersScreen({super.key});

  @override
  State<AiProvidersScreen> createState() => _AiProvidersScreenState();
}

class _AiProvidersScreenState extends State<AiProvidersScreen> {
  bool _checking = true;
  bool _unlocked = false;
  bool _noDeviceLock = false;

  @override
  void initState() {
    super.initState();
    _authenticate();
  }

  Future<void> _authenticate() async {
    final noLock = await BiometricGate.instance.hasNoDeviceSecurity();
    if (noLock) {
      setState(() {
        _noDeviceLock = true;
        _unlocked = true;
        _checking = false;
      });
      return;
    }
    final ok = await BiometricGate.instance.authenticate();
    if (!mounted) return;
    setState(() {
      _unlocked = ok;
      _checking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (!_unlocked) {
      return Scaffold(
        appBar: AppBar(title: const Text('AI Providers')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock_outline, size: 48, color: Theme.of(context).colorScheme.outline),
                const SizedBox(height: 16),
                const Text('Authentication required to manage AI API keys.', textAlign: TextAlign.center),
                const SizedBox(height: 20),
                FilledButton(onPressed: _authenticate, child: const Text('Try again')),
              ],
            ),
          ),
        ),
      );
    }
    return _UnlockedProvidersView(noDeviceLock: _noDeviceLock);
  }
}

class _UnlockedProvidersView extends ConsumerWidget {
  const _UnlockedProvidersView({required this.noDeviceLock});
  final bool noDeviceLock;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vault = ref.watch(apiKeyVaultProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('AI Providers')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (noDeviceLock)
            Card(
              color: Theme.of(context).colorScheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Text(
                  'Your device has no screen lock set up, so this screen couldn\'t be biometric-'
                  'locked. Set up a fingerprint, face, or PIN in your phone\'s settings for '
                  'real protection here.',
                  style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer),
                ),
              ),
            ),
          const SizedBox(height: 12),
          FutureBuilder<AiProvider?>(
            future: vault.getActiveProvider(),
            builder: (context, snapshot) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final provider in AiProvider.values)
                    _ProviderCard(provider: provider, active: snapshot.data == provider),
                ],
              );
            },
          ),
          const SizedBox(height: 12),
          Text(
            'Keys are stored only in this device\'s encrypted keystore — never in the app\'s '
            'database, never synced, never sent anywhere except directly to that provider.',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _ProviderCard extends ConsumerStatefulWidget {
  const _ProviderCard({required this.provider, required this.active});
  final AiProvider provider;
  final bool active;

  @override
  ConsumerState<_ProviderCard> createState() => _ProviderCardState();
}

class _ProviderCardState extends ConsumerState<_ProviderCard> {
  final _ctrl = TextEditingController();
  bool _obscure = true;
  bool _editing = false;
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    final vault = ref.watch(apiKeyVaultProvider);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<String?>(
          future: vault.getKey(widget.provider),
          builder: (context, snapshot) {
            final hasKey = (snapshot.data ?? '').isNotEmpty;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(widget.provider.displayName,
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                    ),
                    if (hasKey)
                      Radio<bool>(
                        value: true,
                        groupValue: widget.active,
                        onChanged: (_) async {
                          await vault.setActiveProvider(widget.provider);
                          if (mounted) setState(() {});
                        },
                      ),
                    if (hasKey) const Text('Active', style: TextStyle(fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  hasKey ? 'Key saved' : 'No key saved yet',
                  style: TextStyle(
                    color: hasKey ? Colors.green : Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 10),
                if (_editing) ...[
                  TextField(
                    controller: _ctrl,
                    obscureText: _obscure,
                    decoration: InputDecoration(
                      labelText: '${widget.provider.displayName} API key',
                      suffixIcon: IconButton(
                        icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          onPressed: _saving ? null : _save,
                          child: _saving
                              ? const SizedBox(
                                  height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2))
                              : const Text('Save'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () => setState(() => _editing = false),
                        child: const Text('Cancel'),
                      ),
                    ],
                  ),
                ] else
                  Wrap(
                    spacing: 8,
                    children: [
                      FilledButton.tonal(
                        onPressed: () => setState(() => _editing = true),
                        child: Text(hasKey ? 'Replace key' : 'Add key'),
                      ),
                      if (hasKey)
                        OutlinedButton(
                          onPressed: () async {
                            await vault.deleteKey(widget.provider);
                            if (mounted) setState(() {});
                          },
                          child: const Text('Remove'),
                        ),
                      TextButton.icon(
                        onPressed: () => launchUrl(Uri.parse(widget.provider.setupUrl),
                            mode: LaunchMode.externalApplication),
                        icon: const Icon(Icons.open_in_new, size: 16),
                        label: const Text('Get a free key'),
                      ),
                    ],
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _save() async {
    final value = _ctrl.text.trim();
    if (value.isEmpty) return;
    setState(() => _saving = true);
    final vault = ref.read(apiKeyVaultProvider);
    await vault.setKey(widget.provider, value);
    final active = await vault.getActiveProvider();
    if (active == null) await vault.setActiveProvider(widget.provider);
    _ctrl.clear();
    if (mounted) {
      setState(() {
        _saving = false;
        _editing = false;
      });
    }
  }
}
