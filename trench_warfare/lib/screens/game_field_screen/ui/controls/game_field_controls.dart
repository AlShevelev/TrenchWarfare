import 'package:flutter/material.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/army_info/game_field_army_info_library.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/cell_info/game_field_cell_info_library.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/game_field_corner_button.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/game_field_general_panel.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/game_field.dart';
import 'package:trench_warfare/screens/game_field_screen/model/game_field_controls_state.dart';

class GameFieldControls extends StatefulWidget {
  static const overlayKey = 'GameFieldControls';

  late final GameFieldForControls _gameField;

  GameFieldControls(GameFieldForControls gameField, {super.key}) {
    _gameField = gameField;
  }

  @override
  State<GameFieldControls> createState() => _GameFieldControlsState();
}

class _GameFieldControlsState extends State<GameFieldControls> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GameFieldControlsState>(
        stream: widget._gameField.controlsState,
        builder: (context, value) {
          if (!value.hasData || value.data is Invisible) {
            return const SizedBox.shrink();
          }

          final state = value.data as Visible;

          final screenWidth = MediaQuery.of(context).size.width;
          final screenHeight = MediaQuery.of(context).size.height;

          return Stack(
            alignment: AlignmentDirectional.topCenter,
            children: [
              GameFieldCornerButton(
                left: 15,
                bottom: 15,
                image: const AssetImage('assets/images/game_field_controls/button_cards.webp'),
                onPress: () {},
              ),
              GameFieldCornerButton(
                right: 15,
                bottom: 15,
                image: const AssetImage('assets/images/game_field_controls/button_next_turn.webp'),
                onPress: () {},
              ),
              GameFieldCornerButton(
                right: 15,
                top: 15,
                image: const AssetImage('assets/images/game_field_controls/button_menu.webp'),
                onPress: () {},
              ),
              GameFieldGeneralPanel(
                money: state.money.currency,
                industryPoints: state.money.industryPoints,
                left: 15,
                top: 0,
              ),
              if (state.cellInfo != null)
                GameFieldCellInfoPanel(
                  cellInfo: state.cellInfo!,
                  spritesAtlas: widget._gameField.spritesAtlas,
                  left: 15,
                  top: 30,
                ),
              if (state.armyInfo != null)
                GameFieldArmyInfoPanel(
                  cellId: state.armyInfo!.cellId,
                  armyInfo: state.armyInfo!,
                  spritesAtlas: widget._gameField.spritesAtlas,
                  left: (screenWidth - GameFieldArmyInfoPanel.width) / 2,
                  top: screenHeight - GameFieldArmyInfoPanel.height,
                  gameField: widget._gameField,
                ),
            ],
          );
        });
  }
}
