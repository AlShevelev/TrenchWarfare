import 'package:flutter/material.dart';
import 'package:trench_warfare/app/theme/colors.dart';
import 'package:trench_warfare/app/theme/typography.dart';

class GameFieldTextButton extends StatelessWidget {
  static const _height = 40.0;

  final String text;

  final Function onPress;

  const GameFieldTextButton({
    super.key,
    required this.onPress,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          // To show a press animation
          Future.delayed(const Duration(milliseconds: 300), () {
            onPress();
          });
        }, // Handle your callback.
        splashColor: AppColors.brown.withOpacity(0.5),
        child: Ink(
          height: _height,
          decoration: BoxDecoration(
            color: AppColors.black.withAlpha(100),
            image: const DecorationImage(
              image: AssetImage('assets/images/game_field_overlays/button_text.webp'),
              fit: BoxFit.fill,
            ),
          ),
          child: Center(
            child: Text(
              text,
              style: AppTypography.s18w600,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
