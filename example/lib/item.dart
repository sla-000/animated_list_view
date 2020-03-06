import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

class Item {
  Item(this.number) : color = _getColor(number);

  final int number;
  final Color color;

  static Color _getColor(int number) {
    final Digest digest = md5.convert(utf8.encode('1234567-$number'));

    return Color.fromARGB(
      0xFF,
      _convertInt(digest.bytes[0]),
      _convertInt(digest.bytes[1]),
      _convertInt(digest.bytes[2]),
    );
  }

  static int _convertInt(int val) {
    const int delta = 170;

    return (val * delta / 255.0).floor() + (255 - delta);
  }

  @override
  String toString() {
    return 'Item{$number}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Item &&
          runtimeType == other.runtimeType &&
          number == other.number;

  @override
  int get hashCode => number.hashCode;
}
