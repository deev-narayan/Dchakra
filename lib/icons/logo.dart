import 'dart:ui';

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

class GlassEffect extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;

  //constructor

  const GlassEffect({
    super.key,
    required this.child,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(6, 248, 223, 140),
                const Color.fromARGB(22, 0, 0, 0),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(child: child),
        ),
      ),
    );
  }
}

class LinrGrage extends StatelessWidget {
  const LinrGrage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color.fromARGB(0, 241, 241, 241),
            const Color.fromARGB(100, 0, 0, 0),
          ],
        ),
      ),
    );
  }
}

class FadeTransitionSample extends StatefulWidget {
  final Widget child;
  final double begin;
  final double end;
  final VoidCallback? onFadeComplete;

  const FadeTransitionSample({
    super.key,
    required this.child,
    required this.begin,
    required this.end,
    this.onFadeComplete,
  });

  @override
  State<FadeTransitionSample> createState() => _FadeTransitionSampleState();
}

class _FadeTransitionSampleState extends State<FadeTransitionSample>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _fadeAnimation = Tween<double>(
      begin: widget.begin,
      end: widget.end,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        widget.onFadeComplete?.call(); // ✅ triggers correctly now
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _fadeAnimation, child: widget.child);
  }
}
