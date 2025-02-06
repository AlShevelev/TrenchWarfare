import 'package:flutter/widgets.dart';
import 'package:trench_warfare/core/enums/nation.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/game_field_controls/game_field_controls_library.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/main/army_info/game_field_army_info_library.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/main/cell_info/game_field_cell_info_library.dart';
import 'package:trench_warfare/shared/ui_kit/corner_button.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/shared/game_field_general_panel.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/game_field.dart';

class MainControlsWidget extends StatelessWidget {
  static const generalPadding = 15.0;

  final MainControls state;

  final GameFieldForControls _gameField;

  final Nation _nation;

  const MainControlsWidget({
    required this.state,
    required GameFieldForControls gameField,
    required Nation nation,
    super.key,
  })  : _gameField = gameField,
        _nation = nation;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final List<Widget> widgets = [];

    widgets.addAll([
      // Disband unit button
      if (state.showDismissButton)
        CornerButton(
          left: generalPadding,
          bottom: CornerButton.size + 2 * generalPadding,
          image: const AssetImage('assets/images/screens/game_field/main/button_disband_unit.webp'),
          onPress: () {
            _gameField.onDisbandUnitButtonClick();
          },
        ),

      // Cards buttons
      CornerButton(
        left: generalPadding,
        bottom: generalPadding,
        image: const AssetImage('assets/images/screens/game_field/main/button_cards.webp'),
        onPress: () {
          _gameField.onCardsButtonClick();
        },
      ),
      // Next turn button
      CornerButton(
        right: generalPadding,
        bottom: generalPadding,
        image: const AssetImage('assets/images/screens/game_field/main/button_next_turn.webp'),
        onPress: () {
          _gameField.onEndOfTurnButtonClick();
        },
      ),
      // Menu button
      CornerButton(
        right: generalPadding,
        top: generalPadding,
        image: const AssetImage('assets/images/screens/game_field/main/button_menu.webp'),
        onPress: () {
          _gameField.onMenuButtonClick();
        },
      ),
      GameFieldGeneralPanel(
        money: state.totalSum,
        nation: _nation,
        left: generalPadding,
        top: 0,
      ),
    ]);

    if (state.cellInfo != null) {
      widgets.add(
        GameFieldCellInfoPanel(
          cellInfo: state.cellInfo!,
          spritesAtlas: _gameField.spritesAtlas,
          left: generalPadding,
          top: 30,
        ),
      );
    }

    if (state.armyInfo != null) {
      widgets.add(
        GameFieldArmyInfoPanel(
          cellId: state.armyInfo!.cellId,
          armyInfo: state.armyInfo!,
          nation: state.armyInfo!.nation,
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
          nation: state.carrierInfo!.nation,
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
