import 'package:flutter/widgets.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/game_field_controls/game_field_controls_library.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/main/army_info/game_field_army_info_library.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/main/cell_info/game_field_cell_info_library.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/shared/game_field_corner_button.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/shared/game_field_general_panel.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/game_field.dart';

class MainControlsWidget extends StatelessWidget {
  final MainControls state;

  late final GameFieldForControls _gameField;

  MainControlsWidget({required this.state, required GameFieldForControls gameField, super.key}) {
    _gameField = gameField;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final List<Widget> widgets = [];

    widgets.addAll([
      // Cards buttons
      GameFieldCornerButton(
        left: 15,
        bottom: 15,
        image: const AssetImage('assets/images/game_field_overlays/main/button_cards.webp'),
        onPress: () {
          _gameField.onCardsButtonClick();
        },
      ),
      // Next turn button
      GameFieldCornerButton(
        right: 15,
        bottom: 15,
        image: const AssetImage('assets/images/game_field_overlays/main/button_next_turn.webp'),
        onPress: () {
          _gameField.onEndOfTurnButtonClick();
        },
      ),
      // Menu button
      GameFieldCornerButton(
        right: 15,
        top: 15,
        image: const AssetImage('assets/images/game_field_overlays/main/button_menu.webp'),
        onPress: () {},
      ),
      GameFieldGeneralPanel(
        money: state.money,
        left: 15,
        top: 0,
      ),
    ]);

    if (state.cellInfo != null) {
      widgets.add(
        GameFieldCellInfoPanel(
          cellInfo: state.cellInfo!,
          spritesAtlas: _gameField.spritesAtlas,
          left: 15,
          top: 30,
        ),
      );
    }

    if (state.armyInfo != null) {
      widgets.add(
        GameFieldArmyInfoPanel(
          cellId: state.armyInfo!.cellId,
          armyInfo: state.armyInfo!,
          spritesAtlas: _gameField.spritesAtlas,
          left: (screenWidth - GameFieldArmyInfoPanel.width) / 2,
          top: screenHeight - GameFieldArmyInfoPanel.height,
          gameField: _gameField,
          isCarrier: false,
        ),
      );
    }

    if (state.carrierInfo != null) {
      widgets.add(
        GameFieldArmyInfoPanel(
          cellId: state.carrierInfo!.cellId,
          armyInfo: state.carrierInfo!,
          spritesAtlas: _gameField.spritesAtlas,
          left: (screenWidth - GameFieldArmyInfoPanel.width) / 2,
          top: screenHeight - GameFieldArmyInfoPanel.height * (state.armyInfo == null ? 1 : 2),
          gameField: _gameField,
          isCarrier: true,
        ),
      );
    }

    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: widgets,
    );
  }
}
