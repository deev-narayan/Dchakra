import 'package:flutter/material.dart';

/// App logo image with optional size.
class AppLogo extends StatelessWidget {
  final double size;

  const AppLogo({super.key, this.size = 120});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset('assets/images/dchakra.png', fit: BoxFit.contain),
    );
  }
}
