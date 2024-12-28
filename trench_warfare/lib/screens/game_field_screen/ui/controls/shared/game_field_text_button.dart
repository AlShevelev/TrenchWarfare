import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trench_warfare/app/theme/colors.dart';
import 'package:trench_warfare/app/theme/typography.dart';
import 'package:trench_warfare/audio/audio_library.dart';
import 'package:trench_warfare/shared/ui_kit/ui_constants.dart';

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
    final audioController = context.read<AudioController>();

    return Material(
      child: InkWell(
        onTap: () {
          audioController.playSound(SoundType.buttonClick);

          // To show a press animation
          Future.delayed(const Duration(milliseconds: UiConstants.pressButtonTime), () {
            onPress();
          });
        }, // Handle your callback.
        splashColor: AppColors.brown.withOpacity(0.5),
        child: Ink(
          height: _height,
          decoration: BoxDecoration(
            color: AppColors.black.withAlpha(100),
            image: const DecorationImage(
              image: AssetImage('assets/images/screens/game_field/button_text.webp'),
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
