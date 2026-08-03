/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

import 'package:easy_localization/easy_localization.dart' as localization;
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:trench_warfare/core/enums/nation.dart';
import 'package:trench_warfare/core/localization/app_locale.dart';
import 'package:trench_warfare/screens/tutorials/ui/controls/tutorial_game_field_controls.dart';
import 'package:trench_warfare/screens/tutorials/ui/tutorial_game_field.dart';
import 'package:trench_warfare/shared/ui_kit/background.dart';

class TutorialsScreen extends StatelessWidget {
  final String _mapFileName = 'assets/tiles/tutorial/tutorial/tutorial.tmx';

  final Nation _selectedNation = Nation.greatBritain;

  const TutorialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocale.fromString((localization.EasyLocalization.of(context)?.locale.toString())!);

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Background(
        imagePath: 'assets/images/screens/game_field/game_field_background.webp',
        child: GameWidget(
          game: TutorialGameField(
            mapFileName: _mapFileName,
            selectedNation: _selectedNation,
            locale: locale,
          ),
          overlayBuilderMap: {
            TutorialGameFieldControls.overlayKey: (BuildContext context, TutorialGameField gameField) {
              return TutorialGameFieldControls(gameField);
            },
          },
        ),
      ),
    );
  }
}