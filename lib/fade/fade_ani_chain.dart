import 'package:dchakra/icons/logo.dart';
import 'package:flutter/material.dart';

class SequentialFadeDemo extends StatefulWidget {
  const SequentialFadeDemo({super.key});

  @override
  State<SequentialFadeDemo> createState() => _SequentialFadeDemoState();
}

class _SequentialFadeDemoState extends State<SequentialFadeDemo> {
  int _step = 0;

  void _nextStep() {
    setState(() {
      _step++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: _step == 0
            ? FadeTransitionSample(
                key: const ValueKey('1'),
                begin: 0.0,
                end: 1.0,
                onFadeComplete: _nextStep,
                child: Text(
                  "Welcome to Dchakra",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40,
                    fontFamily: 'fancy',
                    fontWeight: FontWeight.w100,
                    color: const Color.fromARGB(34, 255, 255, 255),
                  ),
                ),
              )
            : _step == 1
            ? FadeTransitionSample(
                key: const ValueKey('2'),
                begin: 0.0,
                end: 1.0,
                onFadeComplete: _nextStep,
                child: Text(
                  "Hello\nDivyansh",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40,
                    fontFamily: 'fancy',
                    fontWeight: FontWeight.w100,
                    color: const Color.fromARGB(34, 255, 255, 255),
                  ),
                ),
              )
            : Text(
                "Let's begin...",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40,
                  fontFamily: 'fancy',
                  fontWeight: FontWeight.w100,
                  color: const Color.fromARGB(34, 255, 255, 255),
                ),
              ),
      ),
    );
  }
}
