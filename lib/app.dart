import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'data/providers.dart';

class DpbsHubApp extends ConsumerWidget {
  const DpbsHubApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seed = ref.watch(bibleSeedProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'DpbsHub',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      routerConfig: appRouter,
      builder: (context, child) {
        return seed.when(
          data: (_) {
            // Fire-and-forget: seeds reminder defaults + requests
            // notification permission once the app is actually showing,
            // rather than blocking the splash screen behind a permission
            // dialog.
            ref.watch(reminderSetupProvider);
            return child ?? const SizedBox.shrink();
          },
          loading: () => const _SplashScreen(),
          error: (e, st) => _SplashScreen(error: '$e'),
        );
      },
    );
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen({this.error});
  final String? error;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.menu_book, size: 48),
              const SizedBox(height: 16),
              Text(
                error == null ? 'Preparing your study hub…' : 'Setup failed: $error',
                textAlign: TextAlign.center,
              ),
              if (error == null) ...[
                const SizedBox(height: 16),
                const CircularProgressIndicator(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
