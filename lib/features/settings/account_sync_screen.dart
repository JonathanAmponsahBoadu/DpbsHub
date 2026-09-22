import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth/auth_service.dart';
import '../../data/providers.dart';

/// Account & cloud sync. Until Firebase is wired up for this build (a
/// `google-services.json` in `android/app/` plus the Gradle plugin — see the
/// setup instructions you were given), this screen just explains that and
/// nothing else here does any network call. Once it's wired, this becomes a
/// normal "sign in with Google, then sync" screen.
class AccountSyncScreen extends ConsumerWidget {
  const AccountSyncScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firebaseReady = Firebase.apps.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('Account & sync')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (!firebaseReady) const _NotConfiguredCard() else const _SignedInAwareBody(),
        ],
      ),
    );
  }
}

class _NotConfiguredCard extends StatelessWidget {
  const _NotConfiguredCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.cloud_off, color: Theme.of(context).colorScheme.primary, size: 32),
            const SizedBox(height: 12),
            Text('Cloud sync isn\'t set up yet', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            const Text(
              'Your study data stays local-only on this device until a Firebase project '
              'is connected. This is a one-time setup step done outside the app.',
              style: TextStyle(height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}

class _SignedInAwareBody extends ConsumerWidget {
  const _SignedInAwareBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<User?>(
      stream: ref.watch(authServiceProvider).authStateChanges,
      builder: (context, snapshot) {
        final user = snapshot.data;
        if (user == null) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Not signed in', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  SizedBox(height: 8),
                  Text(
                    'Sign in with the same Google account on each device to keep your '
                    'scriptures, notes, tags, talks, and quiz history in sync.',
                    style: TextStyle(height: 1.4),
                  ),
                  SizedBox(height: 16),
                  _SignInButton(),
                ],
              ),
            ),
          );
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: user.photoURL != null ? NetworkImage(user.photoURL!) : null,
                      child: user.photoURL == null ? const Icon(Icons.person) : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.displayName ?? 'Signed in',
                              style: Theme.of(context).textTheme.titleMedium),
                          Text(user.email ?? '', style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const _SyncNowButton(),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () => ref.read(authServiceProvider).signOut(),
                  icon: const Icon(Icons.logout),
                  label: const Text('Sign out'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SignInButton extends ConsumerStatefulWidget {
  const _SignInButton();
  @override
  ConsumerState<_SignInButton> createState() => _SignInButtonState();
}

class _SignInButtonState extends ConsumerState<_SignInButton> {
  bool _busy = false;

  Future<void> _signIn() async {
    setState(() => _busy = true);
    final stopwatch = Stopwatch()..start();
    try {
      await ref.read(authServiceProvider).signInWithGoogle();
    } on AuthFailure catch (e) {
      if (!mounted) return;
      if (e.cancelled) {
        // Android reports the exact same "cancelled" result both when you
        // genuinely back out of the picker AND when the flow can't even
        // start (e.g. this app's certificate fingerprint isn't registered
        // in Firebase yet) — the two are indistinguishable from here. A
        // real cancel always takes at least a couple of seconds (the
        // picker has to render and you have to dismiss it); anything faster
        // than that is almost certainly the latter, so say so.
        final message = stopwatch.elapsed < const Duration(seconds: 2)
            ? "Sign-in closed immediately — that's usually a setup problem (e.g. this app's "
                'certificate fingerprint missing in Firebase), not something you did.'
            : 'Sign-in cancelled.';
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message)));
        return;
      }
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text("Couldn't sign in"),
          content: SingleChildScrollView(child: Text(e.message)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text('Sign-in failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: _busy ? null : _signIn,
      icon: _busy
          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
          : const Icon(Icons.login),
      label: Text(_busy ? 'Signing in…' : 'Sign in with Google'),
    );
  }
}

class _SyncNowButton extends ConsumerStatefulWidget {
  const _SyncNowButton();
  @override
  ConsumerState<_SyncNowButton> createState() => _SyncNowButtonState();
}

class _SyncNowButtonState extends ConsumerState<_SyncNowButton> {
  bool _syncing = false;
  String? _status;

  Future<void> _sync() async {
    setState(() {
      _syncing = true;
      _status = null;
    });
    try {
      await ref.read(syncNowProvider)();
      if (mounted) setState(() => _status = 'Synced just now');
    } catch (e) {
      if (mounted) setState(() => _status = 'Sync failed: $e');
    } finally {
      if (mounted) setState(() => _syncing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FilledButton.icon(
          onPressed: _syncing ? null : _sync,
          icon: _syncing
              ? const SizedBox(
                  width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.sync),
          label: Text(_syncing ? 'Syncing…' : 'Sync now'),
        ),
        if (_status != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(_status!, style: Theme.of(context).textTheme.bodySmall),
          ),
      ],
    );
  }
}
