/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class BackgroundPainter extends CustomPainter {
  late ui.Image _backgroundImage;

  final double topOffset;

  BackgroundPainter({required ui.Image backgroundImage, this.topOffset = 0}) {
    _backgroundImage = backgroundImage;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImageRect(
      _backgroundImage,
      Rect.fromLTWH(
        0,
        0,
        _backgroundImage.width.toDouble(),
        _backgroundImage.height.toDouble(),
      ),
      Rect.fromLTWH(
        0,
        topOffset,
        size.width,
        size.height,
      ),
      Paint(),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
