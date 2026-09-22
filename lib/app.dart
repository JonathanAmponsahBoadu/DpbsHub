import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'data/providers.dart';
import 'shared/widgets/animated_splash.dart';

/// Keeps the splash on screen long enough for its entrance animation to
/// actually be seen — seeding the Bible skeleton is usually near-instant,
/// and a splash that flashes for 200ms just looks like a glitch.
final _splashHoldProvider = FutureProvider<void>(
  (ref) => Future<void>.delayed(const Duration(milliseconds: 1600)),
);

class DpbsHubApp extends ConsumerWidget {
  const DpbsHubApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seed = ref.watch(bibleSeedProvider);
    final hold = ref.watch(_splashHoldProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'DpbsHub',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      routerConfig: appRouter,
      builder: (context, child) {
        final Widget content;
        if (seed.hasError) {
          content = AnimatedSplash(key: const ValueKey('splash-error'), error: '${seed.error}');
        } else if (seed.hasValue && hold.hasValue) {
          // Fire-and-forget: seeds reminder defaults, requests notification
          // permission and rebuilds the reminder/nudge schedule once the app
          // is actually showing, rather than blocking the splash behind a
          // permission dialog.
          ref.watch(reminderSetupProvider);
          content = KeyedSubtree(
            key: const ValueKey('app'),
            child: child ?? const SizedBox.shrink(),
          );
        } else {
          content = const AnimatedSplash(key: ValueKey('splash'));
        }
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: content,
        );
      },
    );
  }
}
