import 'package:flutter/material.dart';
import 'package:trench_warfare/app/theme/colors.dart';
import 'package:trench_warfare/shared/ui_kit/ui_constants.dart';

class CornerButton extends StatelessWidget {
  static const _size = 40.0;

  final double? left;
  final double? top;
  final double? right;
  final double? bottom;

  final ImageProvider image;

  final Function onPress;

  const CornerButton({
    super.key,
    this.left,
    this.top,
    this.right,
    this.bottom,
    required this.image,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      width: _size,
      height: _size,
      child: Material(
        child: InkWell(
          onTap: () {
            // To show a press animation
            Future.delayed(const Duration(milliseconds: UiConstants.pressButtonTime), () {
              onPress();
            });
          }, // Handle your callback.
          splashColor: AppColors.brown.withOpacity(0.5),
          child: Ink(
            height: _size,
            width: _size,
            decoration: BoxDecoration(
              color: AppColors.black.withAlpha(100),
              image: DecorationImage(
                image: image,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
