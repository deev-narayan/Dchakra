import 'package:dchakra/services/locale_service.dart';
import 'package:dchakra/services/tts_service.dart';
import 'package:dchakra/utils/chakra_colors.dart';
import 'package:dchakra/widgets/ambient_background.dart';
import 'package:dchakra/widgets/countdown_timer.dart';
import 'package:flutter/material.dart';

enum SessionPhase { pose, rest }

/// Guided yoga session: pose → rest cycles with TTS cues.
class YogaSessionPage extends StatefulWidget {
  final String name;
  final String color;
  final Map<String, dynamic> yogasana;

  const YogaSessionPage({
    super.key,
    required this.yogasana,
    required this.name,
    required this.color,
  });

  @override
  State<YogaSessionPage> createState() => _YogaSessionPageState();
}

class _YogaSessionPageState extends State<YogaSessionPage> {
  late final PageController _pageController;
  final TtsService _tts = TtsService.instance;
  final LocaleService _locale = LocaleService.instance;

  int _currentPage = 0;
  SessionPhase _phase = SessionPhase.pose;

  static const int poseDuration = 60;
  static const int restDuration = 15;

  List<String> get _poseNames => widget.yogasana.keys.toList();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _tts.init();
  }

  void _speakPose() {
    final name = _poseNames[_currentPage];
    final item = widget.yogasana[name] as Map<String, dynamic>?;
    final steps = item?['steps'] ?? [];
    var text = _locale.cue('start_pose', {
      'seconds': '$poseDuration',
      'name': name,
    });
    text += ' ';
    for (final step in steps) {
      text += '$step. ';
    }
    _tts.speak(text);
  }

  void _onInitialCountdown() {
    if (_phase == SessionPhase.pose) {
      _speakPose();
    } else {
      _tts.speak(_locale.cue('rest'));
    }
  }

  void _onHalfTime() => _tts.speak(_locale.cue('half_time'));

  void _onTimerEnd() {
    if (_phase == SessionPhase.pose) {
      _tts.speak(_locale.cue('stop'));
      if (_currentPage < widget.yogasana.length - 1) {
        setState(() {
          _currentPage++;
          _phase = SessionPhase.rest;
        });
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      } else {
        _tts.speak(_locale.cue('session_complete'));
        _tts.setCompletionHandler(() {
          if (mounted) Navigator.of(context).pop();
        });
      }
    } else {
      setState(() => _phase = SessionPhase.pose);
    }
  }

  Future<void> _goNext() async {
    if (_currentPage >= widget.yogasana.length - 1) {
      await _tts.speak(_locale.cue('session_complete'));
      if (mounted) Navigator.of(context).pop();
      return;
    }
    setState(() {
      if (_phase == SessionPhase.pose) {
        _currentPage++;
      }
      _phase = SessionPhase.pose;
    });
    await _pageController.animateToPage(
      _currentPage,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _goPrev() async {
    if (_currentPage == 0) return;
    setState(() {
      _currentPage--;
      _phase = SessionPhase.pose;
    });
    await _pageController.animateToPage(
      _currentPage,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _tts.stop();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = chakraColor(widget.color);
    final total = widget.yogasana.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                '${_currentPage + 1} / $total',
                style: theme.textTheme.labelLarge,
              ),
            ),
          ),
        ],
      ),
      body: AmbientBackground(
        tint: accent,
        child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: total,
              itemBuilder: (context, index) {
                final name = _poseNames[index];
                final item =
                    widget.yogasana[name] as Map<String, dynamic>?;
                final imagePath = item?['image'] as String? ?? '';

                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Expanded(
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Center(
                              child: FractionallySizedBox(
                                widthFactor: 0.85,
                                heightFactor: 0.85,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: RadialGradient(
                                      colors: [
                                        accent.withValues(alpha: 0.16),
                                        accent.withValues(alpha: 0.0),
                                      ],
                                      stops: const [0.6, 1.0],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: imagePath.isEmpty
                                  ? Icon(Icons.self_improvement,
                                      size: 120, color: accent)
                                  : Image.asset(imagePath, fit: BoxFit.contain),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        name,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 12),
                      Chip(
                        label: Text(
                          _phase == SessionPhase.pose
                              ? _locale.t('hold_pose')
                              : _locale.t('rest_chip'),
                        ),
                        labelStyle: theme.textTheme.labelMedium?.copyWith(
                          color: accent,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                        backgroundColor: accent.withValues(alpha: 0.14),
                        side: BorderSide(color: accent.withValues(alpha: 0.6)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: CountdownTimer(
              key: ValueKey('$_currentPage-$_phase'),
              maxSeconds: _phase == SessionPhase.pose
                  ? poseDuration
                  : restDuration,
              color: accent,
              nextPage: _goNext,
              prevPage: _goPrev,
              onTimerEnd: _onTimerEnd,
              onHalfTime: _onHalfTime,
              onInitialCountdown: _onInitialCountdown,
              onPaused: () {
                _tts.pauseSpeech();
              },
              onResumed: () {
                _tts.resumeSpeech();
              },
            ),
          ),
        ],
      ),
      ),
    );
  }
}
