import 'package:flutter/material.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/game_field_controls/game_field_controls_library.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/main/main_controls_widget.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/game_field.dart';

class TutorialGameFieldControls extends StatefulWidget {
  static const overlayKey = 'TutorialGameFieldControls';

  late final GameFieldForControls _gameField;

  TutorialGameFieldControls(GameFieldForControls gameField, {super.key}) {
    _gameField = gameField;
  }

  @override
  State<TutorialGameFieldControls> createState() => _TutorialGameFieldControlsState();
}

class _TutorialGameFieldControlsState extends State<TutorialGameFieldControls> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          widget._gameField.onPhoneBackAction();
        }
      },
      child: StreamBuilder<GameFieldControlsState>(
          stream: widget._gameField.controlsState,
          builder: (context, value) {
            if (!value.hasData) {
              return const SizedBox.shrink();
            }

            return switch (value.data) {
              MainControls(nation: final nation) => MainControlsWidget(
                state: value.data as MainControls,
                gameField: widget._gameField,
                nation: nation,
              ),
              _ => const SizedBox.shrink(),
            };
          }),
    );
  }
}
