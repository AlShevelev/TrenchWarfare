/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of game_field_sm;

sealed class State {}

class Initial implements State {
  @override
  String toString() => 'INITIAL';
}

class StartTurnInitialConfirmation implements State {
  @override
  String toString() => 'START_TURN_INITIAL_CONFIRMATION';
}

class StartTurnConfirmation implements State {
  @override
  String toString() => 'START_TURN_CONFIRMATION';
}

class ReadyForInput implements State {
  @override
  String toString() => 'READY_FOR_INPUT';
}

class WaitingForEndOfPath implements State {
  final GameFieldCell startPathCell;

  WaitingForEndOfPath(this.startPathCell);

  @override
  String toString() => 'WAITING_FOR_END_OF_PATH: {startPathCell: $startPathCell}';
}

class PathIsShown implements State {
  final Iterable<GameFieldCellRead> path;

  PathIsShown(this.path);

  @override
  String toString() =>
      'PATH_IS_SHOWN: {pathFirst: ${path.first}; pathLast: ${path.last}; pathTotal: ${path.length}}';
}

class MovingInProgress implements State {
  /// The player is win and game must be over
  final bool isVictory;

  /// This player has been defeated but the game is not over
  final Nation? defeated;

  final Iterable<GameFieldCellRead> cellsToUpdate;

  MovingInProgress({
    required this.isVictory,
    required this.defeated,
    required this.cellsToUpdate,
  });

  @override
  String toString() => 'MOVING_IN_PROGRESS: {isVictory: $isVictory; defeated: $defeated}';
}

class CardSelecting implements State {
  @override
  String toString() => 'CARD_SELECTING';
}

class CardPlacing implements State {
  final GameFieldControlsCard card;

  final Map<int, GameFieldCellRead> cellsImpossibleToBuild;

  CardPlacing(this.card, this.cellsImpossibleToBuild);

  @override
  String toString() => 'CARD_PLACING: {card: $card; cellsImpossibleToBuild: ${cellsImpossibleToBuild.length}';
}

class CardPlacingInProgress implements State {
  final GameFieldControlsCard card;

  final Map<int, GameFieldCellRead> newInactiveCells;

  final Map<int, GameFieldCellRead> oldInactiveCells;

  final MoneyUnit productionCost;

  final bool canPlaceNext;

  CardPlacingInProgress({
    required this.card,
    required this.newInactiveCells,
    required this.oldInactiveCells,
    required this.canPlaceNext,
    required this.productionCost,
  });

  @override
  String toString() =>
      'CARD_PLACING_IN_PROGRESS: {card: $card; newInactiveCells: ${newInactiveCells.length}; '
      'oldInactiveCells: ${oldInactiveCells.length}; productionCost: $productionCost; '
      'canPlaceNext: $canPlaceNext}';
}

class TurnIsEnded implements State {
  // todo Maybe whenever in a future we'll store some useful information here
  // (camera position etc.) - to continue our game seamless
  @override
  String toString() => 'TURN_IS_ENDED';
}

class TurnEndConfirmationNeeded implements State {
  final GameFieldCellRead cellToMoveCamera;

  TurnEndConfirmationNeeded(this.cellToMoveCamera);

  @override
  String toString() => 'TURN_END_CONFIRMATION_NEEDED: {cellToMoveCamera: $cellToMoveCamera';
}

class VictoryDefeatConfirmation implements State {
  /// The player is win and game must be over
  final bool isVictory;

  final Iterable<GameFieldCellRead> cellsToUpdate;

  VictoryDefeatConfirmation({
    required this.isVictory,
    required this.cellsToUpdate,
  });

  @override
  String toString() => 'VICTORY_DEFEAT_CONFIRMATION: {isVictory: $isVictory}';
}

class GameIsOver implements State {
  @override
  String toString() => 'GAME_IS_OVER';
}

class MenuIsVisible implements State {
  @override
  String toString() => 'MENU_IS_VISIBLE';
}

class SaveSlotSelection implements State {
  @override
  String toString() => 'SAVE_SLOT_SELECTION';
}

class ObjectivesAreVisible implements State {
  @override
  String toString() => 'OBJECTIVES_ARE_VISIBLE';
}

class SettingsAreVisible implements State {
  @override
  String toString() => 'SETTINGS_ARE_VISIBLE';
}

class DisbandUnitConfirmationNeeded implements State {
  final GameFieldCellRead cellWithUnitToDisband;

  final Iterable<GameFieldCellRead> pathOfUnit;

  final GameFieldControlsState priorUiState;

  DisbandUnitConfirmationNeeded({
    required this.cellWithUnitToDisband,
    required this.pathOfUnit,
    required this.priorUiState,
  });

  @override
  String toString() =>
      'DISBAND_UNIT_CONFIRMATION_NEEDED: {cellWithUnitToDisband: $cellWithUnitToDisband, pathOfUnit total cells: ${pathOfUnit.length}';
}
