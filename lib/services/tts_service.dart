import 'package:dchakra/services/locale_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Shared text-to-speech. Language comes from [LocaleService].
///
/// Pause / resume stays in sync with the session timer and does **not** restart
/// the whole script from the beginning.
class TtsService {
  TtsService._();
  static final TtsService instance = TtsService._();

  final FlutterTts _tts = FlutterTts();
  bool _ready = false;
  bool soundEnabled = true;

  String? _activeText;
  String? _remainingText;
  int _progressEnd = 0;
  bool _paused = false;
  bool _nativePause = false;
  int _speakGeneration = 0;

  /// Web's pause+speak(full) restarts from the top. Use remaining-text instead.
  /// Android / Windows continue correctly when [speak] is called while paused.
  bool get _useNativePauseResume => !kIsWeb;

  Future<void> init() async {
    if (_ready) {
      await _setNormalSpeechRate();
      return;
    }
    _tts.setErrorHandler(_onTtsError);
    _tts.setProgressHandler((text, start, end, word) {
      if (end > _progressEnd) _progressEnd = end;
    });
    _tts.setCompletionHandler(_clearUtteranceState);
    await _setNormalSpeechRate();
    await applyLanguage(LocaleService.instance.label);
    _ready = true;
  }

  void _clearUtteranceState() {
    _paused = false;
    _nativePause = false;
    _remainingText = null;
    _progressEnd = 0;
  }

  void _onTtsError(dynamic message) {
    final text = '$message'.toLowerCase();
    if (text.contains('cancel') ||
        text.contains('interrupt') ||
        text.contains('synthesiserrorevent') ||
        text == 'canceled' ||
        text == 'cancelled') {
      return;
    }
    debugPrint('TTS error: $message');
  }

  Future<void> _setNormalSpeechRate() async {
    final isApple = !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.macOS);
    final isAndroid = !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
    await _tts.setSpeechRate(isApple ? 0.5 : isAndroid ? 0.5 : 1.0);
  }

  Future<void> applyLanguage(String label) async {
    final locale = LocaleService.languages[label]?.$1 ?? 'en-US';
    await _tts.setLanguage(locale);
    await _setNormalSpeechRate();
  }

  /// Start a new utterance (replaces any current speech).
  Future<void> speak(String text) async {
    if (!soundEnabled) return;
    await init();
    final gen = ++_speakGeneration;
    _activeText = text;
    _remainingText = null;
    _progressEnd = 0;
    _paused = false;
    _nativePause = false;
    try {
      await _tts.stop();
    } catch (_) {}
    if (gen != _speakGeneration) return;
    await _tts.speak(text);
  }

  /// Pause with the timer.
  Future<void> pauseSpeech() async {
    if (!soundEnabled) return;
    await init();

    if (_useNativePauseResume) {
      try {
        await _tts.pause();
        _paused = true;
        _nativePause = true;
      } catch (e) {
        debugPrint('TTS pause failed: $e');
      }
      return;
    }

    // Web: snapshot remaining words, then stop (true pause+resume restarts).
    final full = _activeText;
    if (full != null && full.isNotEmpty) {
      final cut = _progressEnd.clamp(0, full.length);
      final leftover = full.substring(cut).trimLeft();
      _remainingText = leftover.isEmpty ? null : leftover;
    } else {
      _remainingText = null;
    }
    _paused = _remainingText != null;
    _nativePause = false;
    try {
      await _tts.stop();
    } catch (_) {}
  }

  /// Continue without repeating already-spoken words.
  Future<void> resumeSpeech() async {
    if (!soundEnabled || !_paused) return;
    await init();

    if (_nativePause) {
      final text = _activeText;
      _paused = false;
      _nativePause = false;
      if (text == null || text.isEmpty) return;
      // Native engines continue mid-utterance when speak() runs while paused.
      try {
        await _tts.speak(text);
      } catch (e) {
        debugPrint('TTS resume failed: $e');
      }
      return;
    }

    final leftover = _remainingText;
    _paused = false;
    _remainingText = null;
    if (leftover == null || leftover.trim().isEmpty) return;

    final gen = ++_speakGeneration;
    _activeText = leftover;
    _progressEnd = 0;
    try {
      await _tts.stop();
    } catch (_) {}
    if (gen != _speakGeneration) return;
    await _tts.speak(leftover);
  }

  /// Hard cancel — use when leaving the session.
  Future<void> stop() async {
    _speakGeneration++;
    _clearUtteranceState();
    _activeText = null;
    try {
      await _tts.stop();
    } catch (_) {}
  }

  void setCompletionHandler(void Function() onDone) {
    _tts.setCompletionHandler(() {
      _clearUtteranceState();
      onDone();
    });
  }
}
