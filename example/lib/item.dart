import 'dart:math';

import 'package:flutter/material.dart';

class Item {
  Item(this.number) : this.color = _getRandomColor();

  final int number;
  final Color color;

  static Color _getRandomColor() {
    return Color.fromARGB(
      0xFF,
      _getRandomInt(),
      _getRandomInt(),
      _getRandomInt(),
    );
  }

  static int _getRandomInt() {
    const delta = 200;
    return Random.secure().nextInt(delta) + 255 - delta;
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
