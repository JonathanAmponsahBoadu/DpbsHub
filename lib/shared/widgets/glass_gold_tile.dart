import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

/// An emerald navigation tile used for the Bible navigation grids (books,
/// chapters, verses) — the same emerald shade used everywhere else in the
/// app. Always shows white text/icons: the emerald fill is its own contrast
/// context, so it reads correctly regardless of light/dark theme.
///
/// [muted] renders a fainter, more translucent emerald fill (e.g. an
/// unstudied chapter) vs the fuller emerald used to draw the eye to a tile
/// (e.g. a chapter you've studied).
///
/// Deliberately no `BackdropFilter`/blur here: these grids are the only
/// place in the app that render dozens of tiles at once (66 books, up to
/// ~150 chapters, more for verses), and a per-tile offscreen blur pass was
/// the actual cause of the Bible tab's navigation jank — expensive GPU work
/// for an effect that was barely visible anyway over a flat background.
class GlassGoldTile extends StatelessWidget {
  const GlassGoldTile({
    super.key,
    required this.child,
    required this.onTap,
    this.muted = false,
    this.borderRadius = 18,
  });

  final Widget child;
  final VoidCallback onTap;
  final bool muted;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final fillOpacity = muted ? 0.32 : 0.92;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.emerald.withValues(alpha: fillOpacity),
              AppTheme.emeraldDeep.withValues(alpha: fillOpacity),
            ],
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: DefaultTextStyle.merge(
              style: const TextStyle(color: Colors.white),
              child: IconTheme.merge(
                data: const IconThemeData(color: Colors.white),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
