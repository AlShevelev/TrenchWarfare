part of game_field_sm;

sealed class State {}

class Initial implements State {}

class ReadyForInput implements State {}

class WaitingForEndOfPath implements State {
  final GameFieldCell startPathCell;

  WaitingForEndOfPath(this.startPathCell);
}

class PathIsShown implements State {
  final Iterable<GameFieldCell> path;

  PathIsShown(this.path);
}

class MovingInProgress implements State {}

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
