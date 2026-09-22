import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_theme.dart';

/// The in-app loading screen shown while the Bible skeleton seeds. Follows
/// the active theme: emerald gradient in light mode, pure black with an
/// emerald glow in dark mode — matching the native launch screen (see
/// android/app/src/main/res/values*/) so the hand-off from the OS splash to
/// this one is seamless instead of flashing white.
class AnimatedSplash extends StatefulWidget {
  const AnimatedSplash({super.key, this.error});

  /// When set, the loading dots are replaced with this message (seeding the
  /// database failed).
  final String? error;

  @override
  State<AnimatedSplash> createState() => _AnimatedSplashState();
}

class _AnimatedSplashState extends State<AnimatedSplash> with TickerProviderStateMixin {
  // One-shot entrance: logo pops in, then the title and tagline follow.
  late final AnimationController _intro =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..forward();

  // Endless loop driving the breathing pulse, ripples and bouncing dots.
  late final AnimationController _loop =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 2400))..repeat();

  @override
  void dispose() {
    _intro.dispose();
    _loop.dispose();
    super.dispose();
  }

  double _interval(double begin, double end, [Curve curve = Curves.easeOut]) =>
      Interval(begin, end, curve: curve).transform(_intro.value);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Emerald on black in dark mode; white on the emerald gradient in light.
    final accent = isDark ? AppTheme.emerald : Colors.white;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: isDark ? Colors.black : null,
        gradient: isDark ? null : AppTheme.heroGradient,
      ),
      child: Material(
        color: Colors.transparent,
        child: AnimatedBuilder(
          animation: Listenable.merge([_intro, _loop]),
          builder: (context, _) {
            final logoScale = 0.4 + 0.6 * _interval(0.0, 0.6, Curves.elasticOut);
            final logoFade = _interval(0.0, 0.25);
            final breathe = 1 + 0.035 * math.sin(2 * math.pi * _loop.value);
            final titleT = _interval(0.35, 0.75);
            final taglineT = _interval(0.5, 0.9);
            final dotsT = _interval(0.6, 1.0);

            return Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 300,
                        height: 300,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CustomPaint(
                              size: const Size(300, 300),
                              painter: _RipplePainter(t: _loop.value, color: accent),
                            ),
                            Container(
                              width: 220,
                              height: 220,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    accent.withValues(alpha: isDark ? 0.32 : 0.22),
                                    accent.withValues(alpha: 0),
                                  ],
                                ),
                              ),
                            ),
                            Opacity(
                              opacity: logoFade.clamp(0.0, 1.0),
                              child: Transform.scale(
                                scale: logoScale * breathe,
                                child: Image.asset(
                                  'assets/icon/app_icon_foreground.png',
                                  width: 240,
                                  height: 240,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Opacity(
                        opacity: titleT.clamp(0.0, 1.0),
                        child: Transform.translate(
                          offset: Offset(0, 16 * (1 - titleT)),
                          child: Text(
                            'DpbsHub',
                            style: GoogleFonts.fredoka(
                              fontSize: 38,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Opacity(
                        opacity: taglineT.clamp(0.0, 1.0),
                        child: Text(
                          'Daily Personal Bible Study',
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white70,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 24,
                  right: 24,
                  bottom: 72 + MediaQuery.paddingOf(context).bottom,
                  child: Opacity(
                    opacity: dotsT.clamp(0.0, 1.0),
                    child: widget.error == null
                        ? _BouncingDots(t: _loop.value, color: accent)
                        : Text(
                            'Setup failed: ${widget.error}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white70),
                          ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Two expanding, fading rings radiating from behind the logo.
class _RipplePainter extends CustomPainter {
  _RipplePainter({required this.t, required this.color});
  final double t;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final maxRadius = size.shortestSide / 2;
    final minRadius = maxRadius * 0.45;
    for (final offset in const [0.0, 0.5]) {
      final p = (t + offset) % 1.0;
      final radius = minRadius + (maxRadius - minRadius) * Curves.easeOut.transform(p);
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5 + 2.5 * (1 - p)
        ..color = color.withValues(alpha: 0.35 * (1 - p));
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(_RipplePainter old) => old.t != t || old.color != color;
}

/// Three dots that bounce in a staggered wave — a friendlier stand-in for
/// the stock spinner.
class _BouncingDots extends StatelessWidget {
  const _BouncingDots({required this.t, required this.color});
  final double t;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < 3; i++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Transform.translate(
              offset: Offset(0, -10 * math.max(0, math.sin(2 * math.pi * (2 * t - i * 0.18)))),
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
            ),
          ),
      ],
    );
  }
}
