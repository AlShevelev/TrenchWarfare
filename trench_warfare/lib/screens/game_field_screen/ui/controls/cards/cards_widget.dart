
import 'package:flutter/widgets.dart';
import 'package:trench_warfare/screens/game_field_screen/model/game_field_controls_state.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/shared/game_field_corner_button.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/shared/game_field_general_panel.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/game_field.dart';
import 'package:trench_warfare/shared/ui_kit/background.dart';

class CardsWidget extends StatelessWidget {
  final Cards state;

  late final GameFieldForControls _gameField;

  CardsWidget({required this.state, required GameFieldForControls gameField, super.key}) {
    _gameField = gameField;
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      imagePath: 'assets/images/game_field_overlays/cards/background.webp',
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(7, 77, 7, 40),
            child: Background(
              imagePath: 'assets/images/game_field_overlays/cards/old_book_cover.webp',
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18),
                    child: Background(
                      imagePath: 'assets/images/game_field_overlays/cards/old_paper.webp',
                      child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Select button
          GameFieldCornerButton(
            left: 15,
            bottom: 15,
            image: const AssetImage('assets/images/game_field_overlays/cards/button_select.webp'),
            onPress: () { },
          ),
          // Close button
          GameFieldCornerButton(
            right: 15,
            bottom: 15,
            image: const AssetImage('assets/images/game_field_overlays/cards/button_close.webp'),
            onPress: () { _gameField.onCardsClose(); },
          ),
          GameFieldGeneralPanel(
            money: state.money.currency,
            industryPoints: state.money.industryPoints,
            left: 15,
            top: 0,
          ),
        ],
      ),
    );
  }
}