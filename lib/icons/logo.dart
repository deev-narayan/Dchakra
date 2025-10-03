import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size;
  const AppLogo({super.key, this.size = 278});

  @override
  Widget build(BuildContext context) {
    // Ratios based on original sizes
    final double border1 = size * (320 / 278);
    final double border2 = size * (418 / 278);
    final double border3 = size * (611 / 278);

    return SizedBox(
      width: border3,
      height: border3,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Third border
          Container(
            height: border3,
            width: border3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(900),
              border: Border.all(
                width: 1,
                color: const Color.fromARGB(8, 255, 255, 255),
              ),
            ),
          ),
          // Second border
          Container(
            height: border2,
            width: border2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(900),
              border: Border.all(
                width: 1,
                color: const Color.fromARGB(13, 255, 255, 255),
              ),
            ),
          ),
          // First border
          Container(
            height: border1,
            width: border1,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(900),
              border: Border.all(
                width: 1,
                color: const Color.fromARGB(38, 255, 255, 255),
              ),
            ),
          ),
          // Main logo image
          SizedBox(
            height: size,
            width: size,
            child: Image.asset('assets/images/dchakra.png'),
          ),
        ],
      ),
    );
  }
}
