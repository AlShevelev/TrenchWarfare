import 'package:trench_warfare/core/entities/money/money_unit.dart';
import 'package:trench_warfare/core/enums/nation.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/game_field_controls/game_field_controls_library.dart';

class TutorialGameFieldControlsState {
  final MoneyUnit totalSum;

  final GameFieldControlsCellInfo? cellInfo;
  final GameFieldControlsArmyInfo? armyInfo;

  final Nation nation;

  final bool showDismissButton;

  TutorialGameFieldControlsState({
    required this.totalSum,
    required this.cellInfo,
    required this.armyInfo,
    required this.nation,
    required this.showDismissButton,
  });

  TutorialGameFieldControlsState setShowDismissButton(bool showDismissButton) =>
      TutorialGameFieldControlsState(
        totalSum: totalSum,
        cellInfo: cellInfo,
        armyInfo: armyInfo,
        nation: nation,
        showDismissButton: showDismissButton,
      );
}
