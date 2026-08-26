import 'package:dchakra/utils/chakra_colors.dart';
import 'package:flutter/material.dart';

/// The signature "sushumna" motif: a thin bar cycling the seven chakra hues
/// from root to crown. Horizontal bars read left→root, right→crown; vertical
/// bars read bottom→root, top→crown (energy rising).
class ChakraSpectrumBar extends StatelessWidget {
  final Axis axis;
  final double thickness;
  final double? length;
  final double opacity;

  const ChakraSpectrumBar({
    super.key,
    this.axis = Axis.horizontal,
    this.thickness = 4,
    this.length,
    this.opacity = 1,
  });

  @override
  Widget build(BuildContext context) {
    final horizontal = axis == Axis.horizontal;
    final gradient = LinearGradient(
      begin: horizontal ? Alignment.centerLeft : Alignment.bottomCenter,
      end: horizontal ? Alignment.centerRight : Alignment.topCenter,
      colors: kChakraSpectrum,
    );

    return Opacity(
      opacity: opacity,
      child: Container(
        width: horizontal ? length : thickness,
        height: horizontal ? thickness : length,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(thickness),
        ),
      ),
    );
  }
}
