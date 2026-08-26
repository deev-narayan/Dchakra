import 'package:dchakra/l10n/app_strings.dart';
import 'package:dchakra/services/tts_service.dart';
import 'package:flutter/foundation.dart';

/// App language. Changing it updates TTS and notifies listeners to reload UI/data.
class LocaleService {
  LocaleService._();
  static final LocaleService instance = LocaleService._();

  /// Display label shown in Settings (English / Hindi / Japanese).
  final ValueNotifier<String> language = ValueNotifier<String>('English');

  /// Display name → (TTS locale, data file suffix).
  static const Map<String, (String tts, String data)> languages = {
    'English': ('en-US', 'en'),
    'Hindi': ('hi-IN', 'hi'),
    'Japanese': ('ja-JP', 'ja'),
  };

  static List<String> get languageLabels => languages.keys.toList();

  String get label => language.value;

  String get dataCode => languages[label]?.$2 ?? 'en';

  /// Asset path for the current language's chakra JSON.
  String get chakraDataPath => 'assets/data/chakras_$dataCode.json';

  Future<void> init() async {
    await TtsService.instance.applyLanguage(label);
  }

  Future<void> setLanguage(String next) async {
    if (!languages.containsKey(next)) return;
    if (language.value == next) return;
    language.value = next;
    await TtsService.instance.applyLanguage(next);
  }

  /// Translate a UI / cue key. Optional `{name}`-style placeholders via [params].
  String t(String key, [Map<String, String>? params]) {
    var text = appStrings[key]?[label] ??
        appStrings[key]?['English'] ??
        key;
    if (params != null) {
      params.forEach((k, v) {
        text = text.replaceAll('{$k}', v);
      });
    }
    return text;
  }

  /// TTS cue helper (same catalog as [t]).
  String cue(String key, [Map<String, String>? params]) => t(key, params);

  /// Translate English color names used in JSON for display.
  String colorLabel(String englishColor) {
    return t('color_${englishColor.toLowerCase()}');
  }
}
