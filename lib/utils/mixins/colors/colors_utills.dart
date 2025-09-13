import 'package:flutter/material.dart';

mixin ColorsUtills {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    String hex = hexString.replaceFirst('#', '').toUpperCase();
    if (hex.length == 6) {
      buffer.write('FF'); // Opacidade padrão
    } else if (hex.length == 8) {
      buffer.write(hex.substring(0, 2)); // Opacidade fornecida
      hex = hex.substring(2);
    }
    buffer.write(hex);
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
