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

  const CornerButton({
    super.key,
    this.left,
    this.top,
    this.right,
    this.bottom,
    required this.image,
    this.enabled = true,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      width: size,
      height: size,
      child: ImageButton.forImages(
        image: image,
        imageWidth: size,
        imageHeight: size,
        enabled: enabled,
        onPress: onPress,
      ),
    );
  }
}
