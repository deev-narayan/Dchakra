import 'dart:convert';

import 'package:dchakra/models/chakra.dart';
import 'package:dchakra/services/locale_service.dart';
import 'package:flutter/services.dart' show rootBundle;

/// Loads chakra list for the current app language.
class ChakraDataService {
  ChakraDataService._();
  static final ChakraDataService instance = ChakraDataService._();

  Future<List<Chakra>> load() async {
    final path = LocaleService.instance.chakraDataPath;
    try {
      return await _parse(path);
    } catch (_) {
      // Fallback to English if a translation file is missing.
      return _parse('assets/data/chakras_en.json');
    }
  }

  Future<List<Chakra>> _parse(String path) async {
    final raw = await rootBundle.loadString(path);
    final list = json.decode(raw) as List<dynamic>;
    return list
        .whereType<Map<String, dynamic>>()
        .map(Chakra.fromJson)
        .toList();
  }
}
