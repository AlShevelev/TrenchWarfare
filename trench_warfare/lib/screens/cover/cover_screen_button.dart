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
import 'package:provider/provider.dart';
import 'package:trench_warfare/app/theme/colors.dart';
import 'package:trench_warfare/app/theme/typography.dart';
import 'package:trench_warfare/audio/audio_library.dart';
import 'package:trench_warfare/shared/ui_kit/stroked_text.dart';

class CoverScreenButton extends StatelessWidget {
  final String text;

  final Function onPress;

  const CoverScreenButton({
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
          Future.delayed(const Duration(milliseconds: 300), () {
            onPress();
          });
        }, // Handle your callback.
        splashColor: AppColors.white.withOpacity(0.25),
        child: Ink(
          //height: _height,
          decoration: BoxDecoration(
            color: AppColors.black.withAlpha(255),
            image: const DecorationImage(
              image: AssetImage('assets/images/screens/cover/cover_button_background.webp'),
              fit: BoxFit.fill,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: StrokedText(
                text: text,
                style: AppTypography.s20w600,
                textColor: AppColors.white,
                strokeColor: AppColors.darkGray,
                strokeWidth: 5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
