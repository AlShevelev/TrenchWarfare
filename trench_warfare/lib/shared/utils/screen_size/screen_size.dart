import 'package:flutter/material.dart';

class ScreenSize {
  static const double _baselineWidth = 411.4; // Pixel 2, Pixel 4XL

  final Size _size;

  bool get isLong => aspectRatio  > 2.0;

  bool get isTablet => _size.shortestSide > 500;

  double get aspectRatio => _size.longestSide / _size.shortestSide;

  double get relativeToBaseline => _size.shortestSide / _baselineWidth;

  ScreenSize(BuildContext context) : _size = MediaQuery.sizeOf(context);
}