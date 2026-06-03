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
import 'package:trench_warfare/shared/ui_kit/image_button.dart';

class CornerButton extends StatelessWidget {
  static const size = 40.0;

  final double? left;
  final double? top;
  final double? right;
  final double? bottom;

  final ImageProvider image;

  final Function onPress;

  final bool enabled;

  final bool showTutorialBorder;

  const CornerButton({
    super.key,
    this.left,
    this.top,
    this.right,
    this.bottom,
    required this.image,
    this.enabled = true,
    this.showTutorialBorder = false,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      width: size + (showTutorialBorder ? 8 : 0),
      height: size + (showTutorialBorder ? 8 : 0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: showTutorialBorder ? Colors.red : Colors.transparent,
            width: showTutorialBorder ? 4.0 : 0.0,
          ),
          borderRadius: BorderRadius.circular(showTutorialBorder ? 4.0 : 0.0),
        ),
        child: ImageButton.forImages(
          image: image,
          imageWidth: size,
          imageHeight: size,
          enabled: enabled,
          onPress: onPress,
        ),
      ),
    );
  }
}
