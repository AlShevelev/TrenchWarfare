import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:trench_warfare/core_entities/enums/nation.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/shared/game_field_text_button.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/game_field.dart';

class MenuDialog extends StatelessWidget {
  final Nation nation;
  final int? day;

  final GameFieldForControls _gameField;

  static const _imagesPath = 'assets/images/game_field_overlays/dialogs/win_defeat_turn/';
  static const _background = '${_imagesPath}card_background.webp';

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
        _gameField.onPopupDialogClosed();
      },
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: DefaultTextStyle(
          style: const TextStyle(),
          child: Padding(
            padding: const EdgeInsets.all(64.0),
            child: Center(
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(_background),
                    fit: BoxFit.fill,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    //crossAxisAlignment: CrossAxisAlignment.stretch,
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
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                        child: GameFieldTextButton(
                          text: tr('save_menu_dialog'),
                          onPress: () {},
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
                        child: GameFieldTextButton(
                          text: tr('load_menu_dialog'),
                          onPress: () {},
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GameFieldTextButton(
                          text: tr('settings_menu_dialog'),
                          onPress: () {},
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
