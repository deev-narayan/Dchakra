import 'package:flutter/material.dart';

/// Pushes [page] onto the navigator. Renders as a filled button in the given
/// chakra [color] (primary actions) or, when [filled] is false, as an outlined
/// button in that hue (secondary actions). An optional [icon] sits before the
/// label.
class PageNavButton extends StatelessWidget {
  final String label;
  final Color color;
  final Widget page;
  final IconData? icon;
  final bool filled;

  const PageNavButton({
    super.key,
    required this.label,
    required this.color,
    required this.page,
    this.icon,
    this.filled = true,
  });

  void _open(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final labelWidget = Text(label);

    if (filled) {
      final style = FilledButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
      );
      return icon == null
          ? FilledButton(
              style: style,
              onPressed: () => _open(context),
              child: labelWidget,
            )
          : FilledButton.icon(
              style: style,
              onPressed: () => _open(context),
              icon: Icon(icon, size: 20),
              label: labelWidget,
            );
    }

    final style = OutlinedButton.styleFrom(
      foregroundColor: color,
      side: BorderSide(color: color.withValues(alpha: 0.55)),
    );
    return icon == null
        ? OutlinedButton(
            style: style,
            onPressed: () => _open(context),
            child: labelWidget,
          )
        : OutlinedButton.icon(
            style: style,
            onPressed: () => _open(context),
            icon: Icon(icon, size: 20),
            label: labelWidget,
          );
  }
}
