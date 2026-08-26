import 'package:dchakra/widgets/soft_card.dart';
import 'package:flutter/material.dart';

/// A soft-card stat row: a hued icon medallion, a label, and a display-face
/// value. Used on the profile and schedule screens.
class StatTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;

  const StatTile({
    super.key,
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SoftCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.14),
              border: Border.all(color: color.withValues(alpha: 0.32)),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(label, style: theme.textTheme.titleMedium),
          ),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
