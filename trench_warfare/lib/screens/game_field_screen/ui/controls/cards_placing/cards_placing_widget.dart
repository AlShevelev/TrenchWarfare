/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

import 'package:flutter/widgets.dart';
import 'package:trench_warfare/core/enums/nation.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/game_field_controls/game_field_controls_library.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/shared/card_photos.dart';
import 'package:trench_warfare/shared/ui_kit/corner_button.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/shared/game_field_general_panel.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/game_field.dart';

class CardPlacingWidget extends StatelessWidget {
  final CardsPlacingControls state;

  final GameFieldForControls _gameField;

  final Nation _nation;

  const CardPlacingWidget({
    required this.state,
    required GameFieldForControls gameField,
    required Nation nation,
    super.key,
  })  : _gameField = gameField,
        _nation = nation;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: [
        // Cancel button
        CornerButton(
          right: 15,
          bottom: 15,
          image: const AssetImage('assets/images/screens/shared/button_close.webp'),
          onPress: () {
            _gameField.onCardsPlacingCancelled();
          },
        ),
        GameFieldGeneralPanel(
          money: state.totalMoney,
          nation: _nation,
          left: 15,
          top: 0,
        ),
        Positioned(
            left: 15,
            bottom: 15,
            child: Image.asset(
              CardPhotos.getPhoto(state.card),
              scale: 3,
            ))
      ],
    );
  }
}
