import 'package:flutter/material.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/cell_info/game_field_cell_info_library.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/game_field_corner_button.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/game_field_general_panel.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/game_field.dart';
import 'package:trench_warfare/screens/game_field_screen/view_model/game_field_controls_state.dart';

class GameFieldControls extends StatefulWidget {
  static const overlayKey = 'GameFieldControls';

  late final GameField _gameField;

  GameFieldControls(GameField gameField, {super.key}) {
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
                money: state.money,
                industryPoints: state.industryPoints,
                left: 15,
                top: 0,
              ),
              if (state.cellInfo != null)
                GameFieldCellInfoPanel(
                  cellInfo: state.cellInfo!,
                  spritesAtlas: widget._gameField.spritesAtlas,
                  left: 15,
                  top: 30,
                )
              else
                const SizedBox.shrink(),
            ],
          );
        });
  }
}
