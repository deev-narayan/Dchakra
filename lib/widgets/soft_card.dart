import 'package:flutter/material.dart';

/// A quiet rounded surface panel with a hairline border and optional tap.
///
/// Replaces ad-hoc Material [Card] usage so every panel in the app shares one
/// radius, one border treatment, and one ripple. Pass [accent] to tint the
/// border with a chakra hue.
class SoftCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final Color? accent;

  const SoftCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
    this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    final radius = BorderRadius.circular(20);
    final border = accent != null
        ? accent!.withValues(alpha: 0.30)
        : theme.colorScheme.onSurface.withValues(alpha: isLight ? 0.08 : 0.14);

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: radius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(color: border),
          ),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
