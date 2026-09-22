import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../data/study_streak.dart';
import '../study_log/log_other_study_sheet.dart';
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
    final streak = ref.watch(studyStreakProvider).value;

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
            if (streak != null) ...[
              const SizedBox(height: 14),
              _StreakCard(streak: streak),
            ],
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
            const SizedBox(height: 12),
            _ActionCard(
              color: AppTheme.emerald,
              icon: Icons.add_task_rounded,
              title: 'Log other study',
              subtitle: 'JW Broadcasting, restudy, drawing… it counts too',
              onTap: () => showLogOtherStudySheet(context),
            ),
          ],
        ),
      ),
    );
  }
}

/// Your streak at a glance: the count, whether today is done, and a tick for
/// each of the last seven days.
class _StreakCard extends StatelessWidget {
  const _StreakCard({required this.streak});
  final StudyStreak streak;

  static const _dayLetters = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final last7 = [
      for (var i = 6; i >= 0; i--) DateTime(today.year, today.month, today.day - i),
    ];

    final String headline;
    final String subline;
    if (streak.studiedToday) {
      headline = '${streak.current}-day streak';
      subline = "You've studied today ✓";
    } else if (streak.current > 0) {
      headline = '${streak.current}-day streak';
      subline = 'Study today to keep it alive';
    } else {
      headline = 'No streak yet';
      subline = 'Log a verse, note or quiz to start one';
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(streak.current > 0 ? '🔥' : '🌱', style: const TextStyle(fontSize: 30)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        headline,
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      Text(
                        subline,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: scheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (final day in last7)
                  _DayDot(
                    letter: _dayLetters[day.weekday - 1],
                    studied: streak.studiedOn(day),
                    isToday: day == today,
                  ),
              ],
            ),
            if (!streak.studiedToday) ...[
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => showLogOtherStudySheet(context),
                  icon: const Icon(Icons.add_task_rounded, size: 18),
                  label: const Text('Studied another way today?'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DayDot extends StatelessWidget {
  const _DayDot({required this.letter, required this.studied, required this.isToday});
  final String letter;
  final bool studied;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Text(
          letter,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isToday ? FontWeight.w800 : FontWeight.w600,
            color: isToday ? AppTheme.emerald : scheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: studied ? AppTheme.emerald : Colors.transparent,
            border: studied
                ? null
                : Border.all(
                    color: isToday ? AppTheme.emerald : scheme.outlineVariant,
                    width: isToday ? 2 : 1.5,
                  ),
          ),
          child: studied ? const Icon(Icons.check_rounded, size: 20, color: Colors.white) : null,
        ),
      ],
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
