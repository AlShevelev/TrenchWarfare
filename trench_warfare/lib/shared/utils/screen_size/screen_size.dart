/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

import 'dart:math' as math;
import 'package:flutter/material.dart';

class ScreenSize {
  static const double _baselineWidth = 411.4; // Pixel 2, Pixel 4XL

  final Size _size;

  bool get isLong => aspectRatio  > 2.0;

  bool get isTablet => _size.shortestSide > 500;

  double get aspectRatio => _size.longestSide / _size.shortestSide;

  double get relativeToBaseline => _size.shortestSide / _baselineWidth;

  double get relativeToBaselineExp => math.pow(relativeToBaseline, 2.5).toDouble();

  ScreenSize(BuildContext context) : _size = MediaQuery.sizeOf(context);
}