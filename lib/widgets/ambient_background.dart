import 'package:flutter/material.dart';

/// A calm full-bleed backdrop: the scaffold background with a soft glow near
/// the top, optionally tinted by a chakra [tint]. Used behind most screens to
/// give the app a quiet, meditative atmosphere.
class AmbientBackground extends StatelessWidget {
  final Widget child;
  final Color? tint;
  final Alignment focal;

  const AmbientBackground({
    super.key,
    required this.child,
    this.tint,
    this.focal = const Alignment(0, -0.9),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    final base = theme.scaffoldBackgroundColor;
    final glow = (tint ?? theme.colorScheme.primary)
        .withValues(alpha: isLight ? 0.12 : 0.20);

    return Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: focal,
              radius: 1.25,
              colors: [glow, base],
              stops: const [0.0, 0.72],
            ),
          ),
        ),
        child,
      ],
    );
  }
}
