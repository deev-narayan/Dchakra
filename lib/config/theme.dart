import 'package:flutter/material.dart';

/// Dchakra visual system — "Sushumna".
///
/// Identity: the seven chakras ascending the spine. A calm gemstone-pigment
/// palette, an airy serif display face for headings, and generous quiet space.
///
/// Typography note: the display font is applied only to large English headings
/// and branding. Body and label text intentionally keep the platform default
/// family so Devanagari (Hindi) and Japanese always render with a proper native
/// font. Where the display font lacks a glyph, Flutter falls back automatically.
class AppTheme {
  AppTheme._();

  /// Elegant display face for headings/branding.
  /// The user supplies the matching .ttf files in `assets/fonts/`
  /// (declared under `fonts:` in pubspec.yaml). If the family is not
  /// registered at runtime, text simply falls back to the platform font.
  static const String displayFont = 'Cormorant';

  // ---- Brand ---------------------------------------------------------------
  /// Third-eye indigo-violet.
  static const Color primary = Color(0xFF5B4B8A);

  /// Heart rose.
  static const Color accent = Color(0xFFC15E7F);

  // ---- Light surfaces (faint "moonstone" warmth, never stark white) --------
  static const Color _lightBg = Color(0xFFF3F1F7);
  static const Color _lightSurface = Color(0xFFFCFBFE);
  static const Color _lightInk = Color(0xFF241F2E);

  // ---- Dark surfaces (deep violet-ink night) -------------------------------
  static const Color _darkBg = Color(0xFF141019);
  static const Color _darkSurface = Color(0xFF1F1928);
  static const Color _darkInk = Color(0xFFEDE7F3);

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    final bg = isLight ? _lightBg : _darkBg;
    final surface = isLight ? _lightSurface : _darkSurface;
    final ink = isLight ? _lightInk : _darkInk;

    final scheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: brightness,
      primary: primary,
      secondary: accent,
      surface: surface,
    ).copyWith(
      // Keep custom surfaces from drifting under Material 3 tinting.
      surfaceTint: Colors.transparent,
    );

    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: bg,
    );

    final text = _textTheme(base.textTheme, ink);
    final hairline = ink.withValues(alpha: isLight ? 0.10 : 0.16);

    return base.copyWith(
      textTheme: text,
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        foregroundColor: ink,
        centerTitle: true,
        titleTextStyle: text.titleLarge?.copyWith(
          fontFamily: displayFont,
          fontSize: 24,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.6,
          color: ink,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        height: 66,
        backgroundColor: isLight
            ? surface.withValues(alpha: 0.92)
            : surface.withValues(alpha: 0.96),
        surfaceTintColor: Colors.transparent,
        indicatorColor: primary.withValues(alpha: isLight ? 0.14 : 0.30),
        indicatorShape: const StadiumBorder(),
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 24,
            color: selected ? primary : ink.withValues(alpha: 0.55),
          );
        }),
        labelTextStyle: WidgetStatePropertyAll(
          text.labelMedium?.copyWith(letterSpacing: 0.3),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: Colors.transparent,
        indicatorColor: primary.withValues(alpha: isLight ? 0.14 : 0.30),
        indicatorShape: const StadiumBorder(),
        selectedIconTheme: IconThemeData(color: primary, size: 26),
        unselectedIconTheme: IconThemeData(
          color: ink.withValues(alpha: 0.55),
          size: 24,
        ),
        selectedLabelTextStyle: text.labelMedium?.copyWith(
          color: primary,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelTextStyle: text.labelMedium?.copyWith(
          color: ink.withValues(alpha: 0.65),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          textStyle: text.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          textStyle: text.labelLarge,
          side: BorderSide(color: hairline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(textStyle: text.labelLarge),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surface,
        side: BorderSide(color: hairline),
        labelStyle: text.labelMedium,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        iconColor: ink.withValues(alpha: 0.7),
        titleTextStyle: text.titleMedium,
        subtitleTextStyle: text.bodySmall,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      dividerTheme: DividerThemeData(
        color: hairline,
        thickness: 1,
        space: 1,
      ),
      iconTheme: IconThemeData(color: ink.withValues(alpha: 0.75)),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primary,
        linearTrackColor: primary.withValues(alpha: 0.14),
        circularTrackColor: primary.withValues(alpha: 0.14),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        titleTextStyle: text.titleLarge,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  /// Type scale. Display/headline sizes use the elegant [displayFont];
  /// title/body/label keep the platform default family for multilingual text.
  static TextTheme _textTheme(TextTheme base, Color ink) {
    final soft = ink.withValues(alpha: 0.86);
    final faint = ink.withValues(alpha: 0.62);

    TextStyle display(double size, {FontWeight weight = FontWeight.w500}) =>
        TextStyle(
          fontFamily: displayFont,
          fontSize: size,
          fontWeight: weight,
          color: ink,
          height: 1.08,
          letterSpacing: 0.2,
        );

    return base.copyWith(
      displayLarge: display(52),
      displayMedium: display(42),
      displaySmall: display(34),
      headlineLarge: display(30, weight: FontWeight.w600),
      headlineMedium: display(26, weight: FontWeight.w600),
      headlineSmall: display(23, weight: FontWeight.w600),
      titleLarge: display(22, weight: FontWeight.w600).copyWith(height: 1.2),
      titleMedium: base.titleMedium?.copyWith(
        color: ink,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        height: 1.3,
      ),
      titleSmall: base.titleSmall?.copyWith(color: ink, height: 1.3),
      bodyLarge: base.bodyLarge?.copyWith(color: soft, height: 1.5),
      bodyMedium: base.bodyMedium?.copyWith(color: soft, height: 1.5),
      bodySmall: base.bodySmall?.copyWith(color: faint, height: 1.45),
      labelLarge: base.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
      labelMedium: base.labelMedium?.copyWith(letterSpacing: 0.4),
      labelSmall: base.labelSmall?.copyWith(
        color: faint,
        letterSpacing: 0.6,
      ),
    );
  }
}
