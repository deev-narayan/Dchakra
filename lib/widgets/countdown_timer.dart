import 'dart:async';

import 'package:flutter/material.dart';

enum TimerPhase { initial, running, ending }

/// Countdown with initial 3s prep, run phase, and ending window.
/// Pause keeps remaining time; resume continues from there (does not restart).
class CountdownTimer extends StatefulWidget {
  final VoidCallback nextPage;
  final VoidCallback prevPage;
  final Color color;
  final int maxSeconds;
  final VoidCallback? onTimerEnd;
  final VoidCallback? onHalfTime;
  final VoidCallback? onPhaseEnd;
  final VoidCallback? onInitialCountdown;
  final VoidCallback? onPaused;
  final VoidCallback? onResumed;

  const CountdownTimer({
    super.key,
    required this.nextPage,
    required this.prevPage,
    required this.color,
    required this.maxSeconds,
    this.onTimerEnd,
    this.onHalfTime,
    this.onPhaseEnd,
    this.onInitialCountdown,
    this.onPaused,
    this.onResumed,
  });

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer>
    with WidgetsBindingObserver {
  late int seconds;
  bool isRunning = false;
  Timer? _timer;
  TimerPhase currentPhase = TimerPhase.initial;
  bool hasSpokenHalfTime = false;
  bool _initialCueFired = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    seconds = 3;
    _beginInitial();
  }

  void _cancelTicker() {
    _timer?.cancel();
    _timer = null;
  }

  void _beginInitial() {
    currentPhase = TimerPhase.initial;
    seconds = 3;
    isRunning = true;
    if (!_initialCueFired) {
      _initialCueFired = true;
      widget.onInitialCountdown?.call();
    }
    _runTicker(_onInitialTick);
    setState(() {});
  }

  void _onInitialTick() {
    if (seconds > 1) {
      setState(() => seconds--);
      return;
    }
    // Leave 0 visible briefly then start main countdown.
    setState(() => seconds = 0);
    _cancelTicker();
    _beginRunning(resetSeconds: true);
  }

  void _beginRunning({required bool resetSeconds}) {
    currentPhase = TimerPhase.running;
    if (resetSeconds) {
      seconds = widget.maxSeconds;
      hasSpokenHalfTime = false;
    }
    isRunning = true;
    _runTicker(_onRunningTick);
    setState(() {});
  }

  void _onRunningTick() {
    if (seconds > 1) {
      setState(() {
        seconds--;
        if (seconds == widget.maxSeconds ~/ 2 && !hasSpokenHalfTime) {
          hasSpokenHalfTime = true;
          widget.onHalfTime?.call();
        }
      });
      return;
    }

    // Last second elapsed → ending cue window.
    setState(() => seconds = 0);
    _cancelTicker();
    _beginEnding();
  }

  void _beginEnding() {
    currentPhase = TimerPhase.ending;
    seconds = 3;
    isRunning = true;
    widget.onPhaseEnd?.call();
    _runTicker(_onEndingTick);
    setState(() {});
  }

  void _onEndingTick() {
    if (seconds > 1) {
      setState(() => seconds--);
      return;
    }
    _cancelTicker();
    setState(() {
      seconds = 0;
      isRunning = false;
    });
    widget.onTimerEnd?.call();
  }

  void _runTicker(VoidCallback onTick) {
    _cancelTicker();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || !isRunning) return;
      onTick();
    });
  }

  void pause() {
    if (!isRunning) return;
    _cancelTicker();
    setState(() => isRunning = false);
    widget.onPaused?.call();
  }

  void resume() {
    if (isRunning) return;
    setState(() => isRunning = true);
    widget.onResumed?.call();

    switch (currentPhase) {
      case TimerPhase.initial:
        _runTicker(_onInitialTick);
      case TimerPhase.running:
        _runTicker(_onRunningTick);
      case TimerPhase.ending:
        _runTicker(_onEndingTick);
    }
  }

  void togglePauseResume() {
    if (isRunning) {
      pause();
    } else {
      resume();
    }
  }

  void _skipPrevious() {
    pause();
    widget.prevPage();
  }

  void _skipNext() {
    pause();
    widget.nextPage();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cancelTicker();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if ((state == AppLifecycleState.paused ||
            state == AppLifecycleState.inactive) &&
        isRunning) {
      pause();
    }
  }

  String get _display {
    if (currentPhase == TimerPhase.initial ||
        currentPhase == TimerPhase.ending) {
      return '$seconds';
    }
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  double get _progress {
    if (currentPhase != TimerPhase.running) {
      return currentPhase == TimerPhase.ending ? 1.0 : 0.0;
    }
    if (widget.maxSeconds <= 0) return 0;
    return (1 - (seconds / widget.maxSeconds)).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _display,
          style: theme.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: _progress,
            minHeight: 8,
            color: widget.color,
            backgroundColor: widget.color.withValues(alpha: 0.2),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.skip_previous),
              onPressed: _skipPrevious,
            ),
            IconButton(
              icon: Icon(isRunning ? Icons.pause : Icons.play_arrow),
              iconSize: 36,
              onPressed: togglePauseResume,
            ),
            IconButton(
              icon: const Icon(Icons.skip_next),
              onPressed: _skipNext,
            ),
          ],
        ),
      ],
    );
  }
}
