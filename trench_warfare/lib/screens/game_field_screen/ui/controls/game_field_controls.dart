import 'package:flutter/material.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/cards/cards_controls_library.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/cards_placing/cards_placing_widget.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/main/main_controls_widget.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/game_field.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/game_field_controls/game_field_controls_library.dart';

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
          if (!value.hasData) {
            return const SizedBox.shrink();
          }

          return switch (value.data) {
            Invisible() => const SizedBox.shrink(),
            // MainControls() => const WinDefeatTurnDialog(
            //     type: WinDefeatTurnDialogType.turn,
            //     nation: Nation.usa,
            //     day: 1,
            //   ),
            MainControls() => MainControlsWidget(
                state: value.data as MainControls,
                gameField: widget._gameField,
              ),
            CardsSelectionControls() => CardsSelectionScreen(
                state: value.data as CardsSelectionControls,
                gameField: widget._gameField,
              ),
            CardsPlacingControls() => CardPlacingWidget(
                state: value.data as CardsPlacingControls,
                gameField: widget._gameField,
              ),
            _ => const SizedBox.shrink(),
          };
        });
  }
}
