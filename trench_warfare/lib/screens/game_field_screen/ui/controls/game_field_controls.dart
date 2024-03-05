import 'package:flutter/material.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/game_field_corner_button.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/game_field.dart';

class GameFieldControls extends StatelessWidget {
  static const overlayKey = 'GameFieldControls';

  late final GameField _gameField;

  GameFieldControls(GameField gameField, {super.key}) {
    _gameField = gameField;
  }

  @override
  Widget build(BuildContext context) {
   return Stack(
     alignment: AlignmentDirectional.topCenter,
     children: [
       GameFieldCornerButton(
         left: 5,
         bottom: 30,
         image: const AssetImage('assets/images/game_field_controls/button_cards.webp'),
         onPress: () {},
       ),
       GameFieldCornerButton(
         right: 5,
         bottom: 30,
         image: const AssetImage('assets/images/game_field_controls/button_next_turn.webp'),
         onPress: () {},
       ),
       GameFieldCornerButton(
         right: 5,
         top: 30,
         image: const AssetImage('assets/images/game_field_controls/button_menu.webp'),
         onPress: () {},
       ),
     ],
   );
  }
}