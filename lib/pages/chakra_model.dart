// TODO Implement this library.
import 'package:flutter/material.dart';

class Chakra {
  final String english;
  final String sanskrit;
  final String symbol;
  final Color color;
  final String desc;

  Chakra({
    required this.english,
    required this.sanskrit,
    required this.symbol,
    required this.color,
    required this.desc,
  });

  factory Chakra.fromJson(Map<String, dynamic> json) {
    return Chakra(
      english: json['english'],
      sanskrit: json['sanskrit'],
      symbol: json['symbol'],
      color: _colorFromHex(json['color']),
      desc: json['desc'],
    );
  }

  static Color _colorFromHex(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 6 || hex.length == 7) buffer.write('ff');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
