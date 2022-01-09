import 'package:flutter/material.dart';

extension StringExtensions on String {
  String capitalizeFirstCharacter() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  String toTitleCase() {
    if (isEmpty) {
      return this;
    }

    String trimmedText = trim();

    if (!trimmedText.contains(" ")) {
      if (trimmedText.length > 1) {
        return trimmedText[0].toUpperCase() + trimmedText.substring(1);
      } else {
        return trimmedText.toUpperCase();
      }
    } else {
      return trimmedText
          .split(" ")
          .map((str) => str[0].toUpperCase() + str.substring(1).toLowerCase())
          .join(" ");
    }
  }

  /// This function converts the Given MAC ADDRESS into [:] separted MAC address with capitalize letters
  ///
  /// Example: This function converts [002624829dc4] or [002624829DC4] into [00:26:24:82:9D:C4] format
  String covertMACIntoDisplayMACFormat() {
    return toString()
        .replaceAllMapped(RegExp(r".{2}"), (match) => "${match.group(0)}:")
        .replaceAll(RegExp(r".$"), "")
        .toUpperCase();
  }

  /// This function convert the String of hexcode into the rgba color string
  String toRgbaString() {
    final buffer = StringBuffer();
    String _hexString = replaceFirst('#', '');

    if (_hexString.length == 6) {
      buffer.write('ff$_hexString');
    } else if (_hexString.length == 8) {
      String _tmpString = _hexString;
      buffer.write(_tmpString.substring(6, _tmpString.length));
      buffer.write(_hexString.substring(0, _hexString.length - 2));
    }

    Color _materialColor = Color(int.parse(buffer.toString(), radix: 16));

    return 'rgba(${_materialColor.red},${_materialColor.green},${_materialColor.blue},${_materialColor.alpha})';
  }
}
