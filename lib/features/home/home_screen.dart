import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../shared/widgets/gradient_surface.dart';
import 'home_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final verses = ref.watch(studiedVersesCountProvider).value ?? 0;
    final notes = ref.watch(notesCountProvider).value ?? 0;
    final quizzes = ref.watch(quizzesTakenCountProvider).value ?? 0;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('DpbsHub',
                    style: theme.textTheme.headlineSmall
                        ?.copyWith(color: AppTheme.emerald, fontWeight: FontWeight.w700)),
                IconButton.filledTonal(
                  icon: const Icon(Icons.settings_outlined),
                  onPressed: () => context.push('/settings'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GradientSurface(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.auto_stories_outlined, size: 22),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text('Keep building your library',
                            style: theme.textTheme.titleLarge
                                ?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      _HeroStat(value: verses, label: 'Verses'),
                      _HeroDivider(),
                      _HeroStat(value: notes, label: 'Notes'),
                      _HeroDivider(),
                      _HeroStat(value: quizzes, label: 'Quizzes'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Text('Quick actions', style: theme.textTheme.titleLarge),
            const SizedBox(height: 14),
            _ActionCard(
              color: AppTheme.emerald,
              icon: Icons.auto_stories_rounded,
              title: 'Add a scripture you studied',
              subtitle: 'Navigate to a verse and log your notes',
              onTap: () => context.go('/bible'),
            ),
            const SizedBox(height: 12),
            _ActionCard(
              color: AppTheme.emerald,
              icon: Icons.record_voice_over_rounded,
              title: 'Log a public talk',
              subtitle: 'Capture outline points to review later',
              onTap: () => context.go('/talks'),
            ),
            const SizedBox(height: 12),
            _ActionCard(
              color: AppTheme.emerald,
              icon: Icons.bolt_rounded,
              title: 'Quiz yourself',
              subtitle: 'Test recall on what you’ve studied',
              onTap: () => context.go('/quiz'),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({required this.value, required this.label});
  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$value',
              style: const TextStyle(
                  color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800)),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
        ],
      ),
    );
  }
}

class _HeroDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 34,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: Colors.white24,
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.color,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  final Color color;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: Colors.white, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 15, color: Colors.white)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.white70),
            ],
          ),
        ),
      ),
    );
  }
}
