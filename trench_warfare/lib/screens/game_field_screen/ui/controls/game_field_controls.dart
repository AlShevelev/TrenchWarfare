import 'package:flutter/material.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/ai_progress/ai_turn_progress_widget.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/cards/cards_controls_library.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/cards_placing/cards_placing_widget.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/dialogs/ask_turn_completed_dialog.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/dialogs/disband/ask_to_disband_dialog.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/dialogs/menu_dialog.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/dialogs/objectives/objectives_dialog.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/dialogs/win_defeat_turn_dialog.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/main/main_controls_widget.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/save_load/save_load_screen.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/settings/settings_screen.dart';
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
              Invisible() => const SizedBox.shrink(),
              MainControls(nation: final nation) => MainControlsWidget(
                  state: value.data as MainControls,
                  gameField: widget._gameField,
                  nation: nation,
                ),
              AiTurnProgress(moneySpending: final moneySpending, unitMovement: final unitMovement) =>
                AiTurnProgressWidget(
                  moneySpending: moneySpending,
                  unitMovement: unitMovement,
                ),
              CardsSelectionControls(nation: final nation) => CardsSelectionScreen(
                  state: value.data as CardsSelectionControls,
                  gameField: widget._gameField,
                  nation: nation,
                ),
              CardsPlacingControls(nation: final nation) => CardPlacingWidget(
                  state: value.data as CardsPlacingControls,
                  gameField: widget._gameField,
                  nation: nation,
                ),
              StartTurnControls(nation: final nation, day: final day) => WinDefeatTurnDialog(
                  type: WinDefeatTurnDialogType.turn,
                  nation: nation,
                  day: day,
                  gameField: widget._gameField,
                ),
              WinControls(nation: final nation) => WinDefeatTurnDialog(
                  type: WinDefeatTurnDialogType.win,
                  nation: nation,
                  gameField: widget._gameField,
                ),
              DefeatControls(nation: final nation, isGlobal: var isGlobal) => WinDefeatTurnDialog(
                  type: isGlobal ? WinDefeatTurnDialogType.defeatGlobal : WinDefeatTurnDialogType.defeat,
                  nation: nation,
                  gameField: widget._gameField,
                ),
              MenuControls(nation: final nation, day: final day) => MenuDialog(
                  nation: nation,
                  day: day,
                  gameField: widget._gameField,
                ),
              SaveControls() => SaveLoadScreen(
                  isSave: true,
                  gameField: widget._gameField,
                ),
              ObjectivesControls() => ObjectivesDialog(
                  gameField: widget._gameField,
                ),
              SettingsControls() => SettingsScreen(
                  gameField: widget._gameField,
                ),
              EndOfTurnConfirmationControls() => AskTurnCompletedDialog(
                  gameField: widget._gameField,
                ),
              DisbandUnitConfirmationControls(unitToShow: final unitToShow, nation: final nation) =>
                AskToDisbandDialog(
                  gameField: widget._gameField,
                  nation: nation,
                  unitToShow: unitToShow,
                ),
              _ => const SizedBox.shrink(),
            };
          }),
    );
  }
}
