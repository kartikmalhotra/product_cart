import 'package:flutter/material.dart';

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    String _hexString = hexString.replaceFirst('#', '');

    if (_hexString.length == 6) {
      buffer.write('ff$_hexString');
    } else if (_hexString.length == 8) {
      String _tmpString = _hexString;
      buffer.write(_tmpString.substring(6, _tmpString.length));
      buffer.write(_hexString.substring(0, _hexString.length - 2));
    }

    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) {
    return '${leadingHashSign ? '#' : ''}'
        '${red.toRadixString(16).padLeft(2, '0')}'
        '${green.toRadixString(16).padLeft(2, '0')}'
        '${blue.toRadixString(16).padLeft(2, '0')}'
        '${alpha.toRadixString(16).padLeft(2, '0')}';
  }

  /// This function convert material color into the rgba color string
  String toRgba() {
    return 'rgba($red,$green,$blue,$alpha)';
  }
}
