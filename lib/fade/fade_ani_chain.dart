import 'package:dchakra/icons/logo.dart';
import 'package:flutter/material.dart';

class SequentialFadeDemo extends StatefulWidget {
  final VoidCallback? onDone; // 👈 callback for when the sequence finishes
  final String username;

  const SequentialFadeDemo({super.key, this.onDone, required this.username});

  @override
  State<SequentialFadeDemo> createState() => _SequentialFadeDemoState();
}

class _SequentialFadeDemoState extends State<SequentialFadeDemo> {
  int _step = 0;

  void _nextStep() {
    setState(() {
      _step++;
    });

    // 👇 when last step is reached, trigger onDone
    if (_step == 2) {
      Future.delayed(const Duration(seconds: 2), () {
        widget.onDone?.call(); // send “done” after showing final text
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      fontSize: 40,
      fontFamily: 'fancy',
      fontWeight: FontWeight.w100,
    );

    return Center(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: _step == 0
            ? FadeTransitionSample(
                key: const ValueKey('1'),
                begin: 0.0,
                end: 1.0,
                onFadeComplete: _nextStep,
                child: const Text(
                  "Welcome to \nDchakra",
                  textAlign: TextAlign.center,
                  style: textStyle,
                ),
              )
            : _step == 1
                ? FadeTransitionSample(
                    key: const ValueKey('2'),
                    begin: 0.0,
                    end: 1.0,
                    onFadeComplete: _nextStep,
                    child: Text(
                      "Hello\n${widget.username}",
                      textAlign: TextAlign.center,
                      style: textStyle,
                    ),
                  )
                : const Text(
                    "Let's begin...",
                    textAlign: TextAlign.center,
                    style: textStyle,
                  ),
      ),
    );
  }
}
