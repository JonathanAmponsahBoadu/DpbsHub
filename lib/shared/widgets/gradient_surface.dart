import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

/// A rounded container filled with the app's signature violet→coral gradient.
/// Reserved for hero/celebration moments so the gradient stays a highlight.
class GradientSurface extends StatelessWidget {
  const GradientSurface({
    super.key,
    required this.child,
    this.gradient = AppTheme.heroGradient,
    this.borderRadius = 28,
    this.padding = const EdgeInsets.all(20),
  });

  final Widget child;
  final Gradient gradient;
  final double borderRadius;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: DefaultTextStyle.merge(
        style: const TextStyle(color: Colors.white),
        child: IconTheme.merge(
          data: const IconThemeData(color: Colors.white),
          child: child,
        ),
      ),
    );
  }
}
