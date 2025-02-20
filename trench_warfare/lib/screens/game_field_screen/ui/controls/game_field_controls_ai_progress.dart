import 'package:flutter/material.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/ai_progress/ai_turn_progress_widget.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/game_field.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/game_field_controls/game_field_controls_library.dart';

class GameFieldControlsAiProgress extends StatefulWidget {
  static const overlayKey = 'GameFieldControlsAiProgress';

  late final GameFieldForControls _gameField;

  GameFieldControlsAiProgress(GameFieldForControls gameField, {super.key}) {
    _gameField = gameField;
  }

  @override
  State<GameFieldControlsAiProgress> createState() => _GameFieldControlsAiProgress();
}

class _GameFieldControlsAiProgress extends State<GameFieldControlsAiProgress> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GameFieldControlsState>(
        stream: widget._gameField.aiProgressState,
        builder: (context, value) {
          if (!value.hasData) {
            return const SizedBox.shrink();
          }

          return switch (value.data) {
            Invisible() => const SizedBox.shrink(),
            AiTurnProgress(moneySpending: final moneySpending, unitMovement: final unitMovement) =>
              AiTurnProgressWidget(
                moneySpending: moneySpending,
                unitMovement: unitMovement,
              ),
            _ => const SizedBox.shrink(),
          };
        });
  }
}
