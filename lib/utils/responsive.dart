import 'package:flutter/material.dart';

/// Breakpoints and spacing for compact (phone) vs wide (tablet/desktop) layouts.
class Responsive {
  Responsive._(this.width);

  final double width;

  static const double compactBreakpoint = 600;
  static const double mediumBreakpoint = 900;

  /// Max content width on large screens so lines don't stretch forever.
  static const double contentMaxWidth = 880;

  factory Responsive.of(BuildContext context) {
    return Responsive._(MediaQuery.sizeOf(context).width);
  }

  bool get isCompact => width < compactBreakpoint;
  bool get isMedium => width >= compactBreakpoint && width < mediumBreakpoint;
  bool get isWide => width >= mediumBreakpoint;

  /// Use side nav (rail) instead of bottom bar.
  bool get useNavigationRail => isWide;

  /// Home chakra list columns.
  int get chakraColumns => isWide ? 2 : 1;

  /// Outer page padding (horizontal / vertical).
  EdgeInsets get pagePadding => EdgeInsets.symmetric(
        horizontal: isCompact ? 16 : (isWide ? 40 : 28),
        vertical: isCompact ? 12 : 24,
      );

  /// List / section gap between items.
  double get itemGap => isCompact ? 8 : 14;

  /// Block gap between major sections.
  double get sectionGap => isCompact ? 20 : 32;

  /// Detail hero avatar radius.
  double get heroRadius => isCompact ? 64 : 96;

  /// Label column width on detail rows.
  double get labelWidth => isCompact ? 88 : 120;

  /// Yoga / mantra session horizontal inset.
  EdgeInsets get sessionPadding => EdgeInsets.symmetric(
        horizontal: isCompact ? 20 : 48,
        vertical: isCompact ? 16 : 28,
      );

  /// Timer control max width on large screens.
  double get timerMaxWidth => isCompact ? double.infinity : 420;
}

/// Centers [child] with responsive padding and a max width on big screens.
class ResponsiveBody extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final bool scrollable;

  const ResponsiveBody({
    super.key,
    required this.child,
    this.padding,
    this.scrollable = false,
  });

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    final pad = padding ?? r.pagePadding;

    Widget content = Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: Responsive.contentMaxWidth),
        child: Padding(
          padding: pad,
          child: child,
        ),
      ),
    );

    if (scrollable) {
      content = SingleChildScrollView(child: content);
    }

    return content;
  }
}
