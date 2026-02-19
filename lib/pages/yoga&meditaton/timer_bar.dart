import 'dart:async';
import 'package:flutter/material.dart';

enum TimerPhase { initial, running, ending }

class CountdownTimer extends StatefulWidget {
  final VoidCallback nextPage;
  final VoidCallback prevPage;
  final Color color;
  final int maxSeconds;
  final VoidCallback? onTimerEnd;
  final VoidCallback? onHalfTime;
  final VoidCallback? onPhaseEnd;
  final VoidCallback? onInitialCountdown;
  const CountdownTimer(
      {super.key,
      required this.nextPage,
      required this.prevPage,
      required this.color,
      required this.maxSeconds,
      this.onTimerEnd,
      this.onHalfTime,
      this.onPhaseEnd,
      this.onInitialCountdown});

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late int seconds;
  bool isRunning = false;
  Timer? timer;
  TimerPhase currentPhase = TimerPhase.initial;
  bool hasSpokenHalfTime = false;

  @override
  void initState() {
    super.initState();
    seconds = 3;
    startInitialCountdown();
  }

  void startInitialCountdown() {
    currentPhase = TimerPhase.initial;
    widget.onInitialCountdown?.call();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (mounted) {
        setState(() {
          if (seconds > 0) {
            seconds--;
          } else {
            t.cancel();
            startTimer();
          }
        });
      }
    });
  }

  void startTimer() {
    currentPhase = TimerPhase.running;
    seconds = widget.maxSeconds;
    hasSpokenHalfTime = false;
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          if (seconds > 3) {
            seconds--;
            if (seconds == widget.maxSeconds ~/ 2 && !hasSpokenHalfTime) {
              hasSpokenHalfTime = true;
              widget.onHalfTime?.call();
            }
          } else if (seconds > 0) {
            seconds--;
            if (seconds == 0) {
              _startEndingCountdown();
            }
          }
        });
      }
    });
    setState(() {
      isRunning = true;
    });
  }

  void _startEndingCountdown() {
    currentPhase = TimerPhase.ending;
    timer?.cancel();
    seconds = 3;
    widget.onPhaseEnd?.call();
    timer = Timer.periodic(const Duration(milliseconds: 100), (t) {
      if (mounted) {
        setState(() {
          if (seconds > 0) {
            seconds--;
          } else {
            t.cancel();
            widget.onTimerEnd?.call();
            resetTimer();
          }
        });
      }
    });
  }

  void stopTimer() {
    timer?.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void resetTimer() {
    timer?.cancel();
    setState(() {
      seconds = widget.maxSeconds;
      isRunning = false;
      currentPhase = TimerPhase.running;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double fullWidth = 320;
    double height = 80;
    double progress = 1 - (seconds / widget.maxSeconds);
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Text(
            (currentPhase == TimerPhase.initial ||
                    currentPhase == TimerPhase.ending)
                ? seconds.toString()
                : () {
                    int minutes = seconds ~/ 60;
                    int secs = seconds % 60;
                    return "${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
                  }(),
            style: theme.textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onBackground,
            ),
          ),
        ),
        const SizedBox(height: 15),
        Container(
          color: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Stack(
              children: [
                // Main container background - REMOVED/TRANSPARENT
                Container(
                  width: fullWidth,
                  height: height,
                  decoration: BoxDecoration(
                    color: Colors.transparent, // Made transparent to use parent's glassmorphism
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                // Progress bar inside container (width only!)
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    width: fullWidth * progress,
                    height: height,
                    decoration: BoxDecoration(
                      color: widget.color.withOpacity(0.8),
                      borderRadius: BorderRadius.horizontal(
                        left: const Radius.circular(25),
                        right: Radius.circular(progress == 1 ? 25 : 2),
                      ),
                    ),
                  ),
                ),
                // Button row
                SizedBox(
                  width: fullWidth,
                  height: height,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios,
                            color: theme.colorScheme.onSurface),
                        onPressed: () {
                          widget.prevPage();
                          resetTimer();
                        },
                      ),
                      IconButton(
                        icon: Icon(
                            isRunning ? Icons.pause : Icons.play_arrow,
                            color: theme.colorScheme.onSurface),
                        onPressed: () {
                          if (isRunning) {
                            stopTimer();
                          } else {
                            startTimer();
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_forward_ios,
                            color: theme.colorScheme.onSurface),
                        onPressed: () {
                          widget.nextPage();
                          resetTimer();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
