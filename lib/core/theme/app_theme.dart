import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// DpbsHub's visual identity: emerald as the single signature color, bold
/// rounded shapes, and a playful rounded display face (Fredoka) paired with
/// a warm, highly readable body face (Nunito). Bible navigation grids get a
/// separate gold "glass" treatment (see shared/widgets/glass_gold_tile.dart)
/// to feel special without pulling gold into the general interface.
class AppTheme {
  AppTheme._();

  static const emerald = Color(0xFF17A673);
  static const emeraldDeep = Color(0xFF0C7A54);
  static const amber = Color(0xFFFFB020);
  static const sky = Color(0xFF2E9BF7);
  static const burntOrange = Color(0xFFFF6F47);

  // Gold, reserved for the glass-coated Bible navigation grids only.
  static const gold = Color(0xFFD9A62B);
  static const goldLight = Color(0xFFF3D27A);
  static const goldDeep = Color(0xFFB9860F);

  // Testament indicator dots on the Bible book grid — a high-contrast pair
  // (deliberately not two more shades of the app's emerald/gold palette, so
  // the two halves of the Bible stay visually distinct at a glance).
  static const testamentHebrew = Color(0xFFB5432E); // brick red
  static const testamentGreek = Color(0xFF1E3A8A); // deep blue

  // Signature gradient — a single hue (emerald) for depth, used sparingly on
  // hero surfaces (home header, results celebration) so it reads as "just
  // emerald" rather than a multi-color effect.
  static const heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [emerald, emeraldDeep],
  );

  /// A small curated set for *purposeful* variety (e.g. distinct quick-action
  /// tiles on Home) — not meant for coloring repeated items in a single list/
  /// grid, where one consistent color reads far cleaner than a rotation.
  static const accentRotation = [emerald, amber, sky, burntOrange];

  // A single fixed emerald is used as `primary` in BOTH light and dark mode
  // (rather than swapping to a lighter tone in dark mode, which is the usual
  // Material approach) so every emerald surface in the app — hero card,
  // Bible tiles, nav bar, FAB — reads as the exact same shade everywhere.
  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: emerald,
      brightness: Brightness.light,
    ).copyWith(
      primary: emerald,
      onPrimary: Colors.white,
      secondary: amber,
      tertiary: sky,
      surface: const Color(0xFFFBFAF3),
    );
    return _base(scheme);
  }

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: emerald,
      brightness: Brightness.dark,
    ).copyWith(
      primary: emerald,
      onPrimary: Colors.white,
      secondary: amber,
      tertiary: sky,
      surface: const Color(0xFF13201A),
    );
    return _base(scheme);
  }

  static ThemeData _base(ColorScheme scheme) {
    // GoogleFonts.xTextTheme() with no argument bakes in a fixed near-black
    // palette regardless of brightness — that silently broke dark-mode
    // contrast everywhere text didn't set an explicit color. Seed it from the
    // brightness-correct Material typography instead so every style (and the
    // Fredoka/Nunito overrides below, via `textStyle:` to inherit color) ends
    // up white-on-dark / dark-on-light automatically.
    final materialBase = scheme.brightness == Brightness.dark
        ? Typography.material2021().white
        : Typography.material2021().black;
    final nunito = GoogleFonts.nunitoTextTheme(materialBase);
    final textTheme = nunito.copyWith(
      displayLarge: GoogleFonts.fredoka(textStyle: nunito.displayLarge, fontWeight: FontWeight.w600),
      displayMedium: GoogleFonts.fredoka(textStyle: nunito.displayMedium, fontWeight: FontWeight.w600),
      displaySmall: GoogleFonts.fredoka(textStyle: nunito.displaySmall, fontWeight: FontWeight.w600),
      headlineLarge: GoogleFonts.fredoka(textStyle: nunito.headlineLarge, fontWeight: FontWeight.w600),
      headlineMedium: GoogleFonts.fredoka(textStyle: nunito.headlineMedium, fontWeight: FontWeight.w600),
      headlineSmall: GoogleFonts.fredoka(textStyle: nunito.headlineSmall, fontWeight: FontWeight.w600),
      titleLarge: GoogleFonts.fredoka(textStyle: nunito.titleLarge, fontWeight: FontWeight.w600),
      titleMedium: GoogleFonts.nunito(textStyle: nunito.titleMedium, fontWeight: FontWeight.w800),
      labelLarge: GoogleFonts.nunito(textStyle: nunito.labelLarge, fontWeight: FontWeight.w800),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      textTheme: textTheme,
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.fredoka(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: scheme.onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surfaceContainerHigh,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        margin: EdgeInsets.zero,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.secondaryContainer,
        labelStyle:
            TextStyle(color: scheme.onSecondaryContainer, fontWeight: FontWeight.w700),
        shape: const StadiumBorder(),
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
          textStyle: GoogleFonts.nunito(fontWeight: FontWeight.w800, fontSize: 16),
          shape: const StadiumBorder(),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
          shape: const StadiumBorder(),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: GoogleFonts.nunito(fontWeight: FontWeight.w800),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        indicatorColor: scheme.primary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        height: 70,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => GoogleFonts.nunito(
            fontWeight: FontWeight.w800,
            fontSize: 12,
            color: states.contains(WidgetState.selected) ? scheme.primary : scheme.onSurfaceVariant,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? scheme.onPrimary
                : scheme.onSurfaceVariant,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        shape: const StadiumBorder(),
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
      ),
    );
  }
}
