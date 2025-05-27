/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:trench_warfare/app/theme/typography.dart';
import 'package:trench_warfare/core/entities/game_objects/game_object_library.dart';
import 'package:trench_warfare/core/enums/nation.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/dialogs/disband/ask_to_disband_dialog_unit_painter.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/game_field.dart';
import 'package:trench_warfare/shared/ui_kit/cardboard.dart';
import 'package:trench_warfare/shared/ui_kit/image_button.dart';

class AskToDisbandDialog extends StatelessWidget {
  static const _iconSize = 35.0;
  static const _unitIconSize = 65.0;

  final GameFieldForControls _gameField;

  final Unit _unitToShow;

  final Nation _nation;

  const AskToDisbandDialog({
    super.key,
    required GameFieldForControls gameField,
    required Unit unitToShow,
    required Nation nation,
  })  : _gameField = gameField,
        _unitToShow = unitToShow,
        _nation = nation;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: DefaultTextStyle(
        style: const TextStyle(),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Cardboard(
                child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      tr('ask_to_disband_dialog'),
                      style: AppTypography.s18w600,
                      textAlign: TextAlign.center,
                    ),
                    CustomPaint(
                      painter: AskToDisbandDialogUnitPainter(
                        unit: _unitToShow,
                        nation: _nation,
                        spritesAtlas: _gameField.spritesAtlas,
                      ),
                      child: const SizedBox(
                        width: _unitIconSize,
                        height: _unitIconSize,
                        child: null,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 24, 0),
                            child: ImageButton.forBlackIcons(
                              image: AssetImage(_getIcon('icon_yes')),
                              imageWidth: _iconSize,
                              imageHeight: _iconSize,
                              onPress: () => _gameField.onUserConfirmed(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 0, 0, 0),
                            child: ImageButton.forBlackIcons(
                              image: AssetImage(_getIcon('icon_no')),
                              imageWidth: _iconSize,
                              imageHeight: _iconSize,
                              onPress: () => _gameField.onUserDeclined(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
          ),
        ),
      ),
    );
  }

  String _getIcon(String name) => 'assets/images/screens/game_field/dialogs/$name.webp';
}
