import 'package:dchakra/widgets/chakra_spectrum.dart';
import 'package:flutter/material.dart';

/// A screen/section heading in the display face, underlined by a short
/// chakra-spectrum tick, with an optional subtitle.
class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  const SectionHeader({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sub = subtitle;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.displaySmall),
        const SizedBox(height: 12),
        const ChakraSpectrumBar(thickness: 4, length: 76),
        if (sub != null) ...[
          const SizedBox(height: 14),
          Text(sub, style: theme.textTheme.bodyMedium),
        ],
      ],
    );
  }
}
