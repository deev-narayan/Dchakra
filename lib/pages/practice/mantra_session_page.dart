import 'package:dchakra/services/locale_service.dart';
import 'package:dchakra/services/tts_service.dart';
import 'package:dchakra/widgets/ambient_background.dart';
import 'package:dchakra/widgets/countdown_timer.dart';
import 'package:dchakra/widgets/looping_audio.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// Mantra meditation session with looping audio + countdown.
class MantraSessionPage extends StatefulWidget {
  final String chakraName;
  final Color accentColor;
  final String audioUrl;
  final String lottieAsset;

  const MantraSessionPage({
    super.key,
    required this.chakraName,
    required this.accentColor,
    required this.audioUrl,
    this.lottieAsset = '',
  });

  @override
  State<MantraSessionPage> createState() => _MantraSessionPageState();
}

class _MantraSessionPageState extends State<MantraSessionPage>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  final TtsService _tts = TtsService.instance;
  final ValueNotifier<bool> _audioPaused = ValueNotifier<bool>(false);
  late final AnimationController _lottieController;
  bool _lottieLoaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _tts.init();
    _lottieController = AnimationController(vsync: this);
    // Keep the mandala loop in step with the session's pause state
    // (same notifier that drives the looping audio).
    _audioPaused.addListener(_syncLottie);
  }

  /// Freeze the mandala while paused; resume its loop otherwise.
  void _syncLottie() {
    if (!_lottieLoaded) return;
    if (_audioPaused.value) {
      _lottieController.stop();
    } else {
      _lottieController.repeat();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _audioPaused.removeListener(_syncLottie);
    _lottieController.dispose();
    _audioPaused.dispose();
    _tts.stop();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _audioPaused.value = true;
      _tts.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.chakraName)),
      body: AmbientBackground(
        tint: widget.accentColor,
        focal: const Alignment(0, -0.15),
        child: SafeArea(
          child: Column(
            children: [
              if (widget.audioUrl.isNotEmpty)
                LoopingAudio(
                  assetPath: widget.audioUrl,
                  paused: _audioPaused,
                ),
              // Mandala on top, taking the available space above the timer.
              Expanded(
                child: widget.lottieAsset.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(28),
                        child: Center(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  widget.accentColor.withValues(alpha: 0.18),
                                  widget.accentColor.withValues(alpha: 0.0),
                                ],
                                stops: const [0.55, 1.0],
                              ),
                            ),
                            child: Lottie.asset(
                              widget.lottieAsset,
                              controller: _lottieController,
                              fit: BoxFit.contain,
                              onLoaded: (composition) {
                                _lottieController.duration =
                                    composition.duration;
                                _lottieLoaded = true;
                                if (!_audioPaused.value) {
                                  _lottieController.repeat();
                                }
                              },
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              // Countdown timer below the mandala.
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: CountdownTimer(
                  color: widget.accentColor,
                  maxSeconds: 300,
                  nextPage: () {},
                  prevPage: () {},
                  onPaused: () {
                    _audioPaused.value = true;
                    _tts.pauseSpeech();
                  },
                  onResumed: () {
                    _audioPaused.value = false;
                    _tts.resumeSpeech();
                  },
                  onTimerEnd: () async {
                    _audioPaused.value = true;
                    await _tts.speak(
                      LocaleService.instance.cue('meditation_complete'),
                    );
                    await Future.delayed(const Duration(seconds: 1));
                    if (!context.mounted) return;
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
