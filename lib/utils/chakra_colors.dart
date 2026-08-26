import 'package:flutter/material.dart';

/// The seven chakra hues as refined "gemstone pigments" (root → crown).
///
/// Tuned to feel like natural minerals rather than raw primary colors, so the
/// palette reads as calm and sacred while staying instantly recognizable.
const Color kMuladhara = Color(0xFFB23A48); // root — deep madder red
const Color kSwadhisthana = Color(0xFFD46A3C); // sacral — burnt amber
const Color kManipura = Color(0xFFE0A73E); // solar plexus — turmeric gold
const Color kAnahata = Color(0xFF5A9E6F); // heart — jade green
const Color kVishuddha = Color(0xFF3C86B5); // throat — lapis blue
const Color kAjna = Color(0xFF4A579E); // third eye — indigo
const Color kSahasrara = Color(0xFF7E4E9E); // crown — amethyst violet

/// Ascending spectrum (root → crown) — the app's signature "sushumna" motif.
const List<Color> kChakraSpectrum = <Color>[
  kMuladhara,
  kSwadhisthana,
  kManipura,
  kAnahata,
  kVishuddha,
  kAjna,
  kSahasrara,
];

/// Vertical gradient of the ascending spectrum (root at the bottom).
const LinearGradient kSushumnaGradient = LinearGradient(
  begin: Alignment.bottomCenter,
  end: Alignment.topCenter,
  colors: kChakraSpectrum,
);

/// Maps chakra color names from JSON to their UI hue.
Color chakraColor(String colorName) {
  switch (colorName.toLowerCase()) {
    case 'red':
      return kMuladhara;
    case 'orange':
      return kSwadhisthana;
    case 'yellow':
      return kManipura;
    case 'green':
      return kAnahata;
    case 'blue':
      return kVishuddha;
    case 'indigo':
      return kAjna;
    case 'violet':
      return kSahasrara;
    default:
      return const Color(0xFF8A8296);
  }
}
