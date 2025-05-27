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
import 'package:trench_warfare/core/enums/nation.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/shared/game_field_text_button.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/game_field.dart';
import 'package:trench_warfare/shared/ui_kit/cardboard.dart';

class MenuDialog extends StatelessWidget {
  final Nation nation;
  final int? day;

  final GameFieldForControls _gameField;

  const MenuDialog({
    super.key,
    required this.nation,
    this.day,
    required GameFieldForControls gameField,
  }) : _gameField = gameField;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _gameField.onPopupDialogClosed(fireCallbackForAi: false);
      },
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: DefaultTextStyle(
          style: const TextStyle(),
          child: Padding(
            padding: const EdgeInsets.all(64.0),
            child: Center(
              child: Cardboard(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GameFieldTextButton(
                          text: tr('resume_menu_dialog'),
                          onPress: () {
                            _gameField.onPhoneBackAction();
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GameFieldTextButton(
                          text: tr('save'),
                          onPress: () {
                            _gameField.onMenuSaveButtonClick();
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GameFieldTextButton(
                          text: tr('settings_menu_dialog'),
                          onPress: () {
                            _gameField.onMenuSettingsButtonClick();
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GameFieldTextButton(
                          text: tr('objectives_menu_dialog'),
                          onPress: () {
                            _gameField.onMenuObjectivesButtonClick();
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GameFieldTextButton(
                          text: tr('quit_menu_dialog'),
                          onPress: () {
                            _gameField.onMenuQuitButtonClick();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
