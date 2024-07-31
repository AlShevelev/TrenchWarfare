part of game_field_sm;

sealed class State {}

class Initial implements State {}

class StartTurnInitialConfirmation implements State {}

class StartTurnConfirmation implements State {}

class ReadyForInput implements State {}

class WaitingForEndOfPath implements State {
  final GameFieldCell startPathCell;

  WaitingForEndOfPath(this.startPathCell);
}

class PathIsShown implements State {
  final Iterable<GameFieldCellRead> path;

  PathIsShown(this.path);
}

class MovingInProgress implements State {
  /// The player is win and game must be over
  final bool isVictory;

  /// This player has been defeated but the game is not over
  final Nation? defeated;

  MovingInProgress({required this.isVictory, required this.defeated});
}

class CardSelecting implements State {}

class CardPlacing implements State {
  final GameFieldControlsCard card;

  final Map<int, GameFieldCellRead> cellsImpossibleToBuild;

  CardPlacing(this.card, this.cellsImpossibleToBuild);
}

class CardPlacingSpecialStrikeInProgress implements State {
  final GameFieldControlsCard card;

  final Map<int, GameFieldCellRead> newInactiveCells;

  final Map<int, GameFieldCellRead> oldInactiveCells;

  final MoneyUnit productionCost;

  final bool canPlaceNext;

  CardPlacingSpecialStrikeInProgress({
    required this.card,
    required this.newInactiveCells,
    required this.oldInactiveCells,
    required this.canPlaceNext,
    required this.productionCost,
  });
}

class TurnIsEnded implements State {
  // todo Maybe whenever in a future we'll store some useful information here
  // (camera position etc.) - to continue our game seamless
}

class VictoryDefeatConfirmation implements State {
  /// The player is win and game must be over
  final bool isVictory;

  VictoryDefeatConfirmation({required this.isVictory});
}

class GameIsOver implements State {}
