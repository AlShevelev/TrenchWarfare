/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

import 'package:flutter/material.dart';
import 'package:trench_warfare/app/theme/colors.dart';

/// Text with stroke
class StrokedText extends StatelessWidget {
  const StrokedText({
    super.key,
    required this.text,
    this.textColor = AppColors.brown,
    this.strokeColor = AppColors.white,
    this.strokeWidth = 3.0,
    required this.style,
  });

  final String text;
  final Color textColor;
  final Color strokeColor;
  final double strokeWidth;
  final TextStyle style;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // Stroked text as border.
        Text(
          text,
          style: TextStyle(
            fontFamily: style.fontFamily,
            fontSize: style.fontSize,
            fontWeight: style.fontWeight,
            decoration: TextDecoration.none,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth
              ..color = strokeColor,
          ),
        ),
        // Solid text as fill.
        Text(
          text,
          style: TextStyle(
            fontFamily: style.fontFamily,
            fontSize: style.fontSize,
            fontWeight: style.fontWeight,
            color: textColor,
            decoration: TextDecoration.none,
          ),
        ),
      ],
    );
  }
}
