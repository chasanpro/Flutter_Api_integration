import 'package:flutter/material.dart';

Color bright = Colors.white;

class HexColor extends Color {
  static int _getColor(String hex) {
    String formattedHex = "FF${hex.toUpperCase().replaceAll("#", "")}";
    return int.parse(formattedHex, radix: 16);
  }

  HexColor(final String hex) : super(_getColor(hex));
}

Color coralColor = HexColor("#7079a3");
Color startcolor = HexColor("#b8cce4");
Color endColor = HexColor("#c8b4dc");
Color dark = HexColor("#252525");
final List<Color> gradcolor = [
  Color.fromARGB(255, 165, 64, 202),
  Color.fromARGB(255, 246, 197, 204),
  Color.fromARGB(255, 237, 211, 211),
  Color.fromARGB(255, 174, 169, 216)
];
