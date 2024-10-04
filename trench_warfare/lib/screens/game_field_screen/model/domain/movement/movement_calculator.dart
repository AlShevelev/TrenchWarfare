part of movement;

abstract class MovementCalculator {
  @protected
  final GameFieldRead _gameField;

  @protected
  final Nation _nation;

  @protected
  final SingleStream<Iterable<UpdateGameEvent>> _updateGameObjectsEvent;

  @protected
  final PathFacade _pathFacade;

  @protected
  final GameOverConditionsCalculator _gameOverConditionsCalculator;

  MovementCalculator({
    required GameFieldRead gameField,
    required Nation nation,
    required SingleStream<Iterable<UpdateGameEvent>> updateGameObjectsEvent,
    required GameOverConditionsCalculator gameOverConditionsCalculator,
  })  : _gameField = gameField,
        _nation = nation,
        _updateGameObjectsEvent = updateGameObjectsEvent,
        _pathFacade = PathFacade(gameField),
        _gameOverConditionsCalculator = gameOverConditionsCalculator;

  State startMovement(Iterable<GameFieldCell> path);

  @protected
  bool _canMove({required GameFieldCell startCell}) => _pathFacade.canMove(startCell);

  @protected
  bool _canMoveForUnit({
    required GameFieldCell startCell,
    required Unit unit,
  }) =>
      _pathFacade.canMoveForUnit(startCell, unit);

  @protected
  Unit _detachActiveUnit(Iterable<GameFieldCell> path) {
    final activeUnit = path.first.activeUnit!;
    final secondPathCell = path.elementAt(1);

    if (activeUnit is Carrier && secondPathCell.isLand && !secondPathCell.hasRiver) {
      activeUnit.setState(UnitState.enabled);
      return activeUnit.removeActiveUnit();
    } else {
      return path.first.removeActiveUnit();
    }
  }

  @protected
  void _attachUnit(GameFieldCell cell, Unit unit) {
    if (cell.activeUnit is Carrier && unit.isLand) {
      (cell.activeUnit as Carrier).addUnitAsActive(unit);
    } else {
      cell.addUnitAsActive(unit);
    }
  }

  State _getNextState() {
    final gameOverConditions = _gameOverConditionsCalculator.calculate(_nation);

    return switch (gameOverConditions) {
      GlobalVictory() => MovingInProgress(isVictory: true, defeated: null, cellsToUpdate: []),
      Defeat(nation: var nation) => MovingInProgress(
          isVictory: false,
          defeated: nation,
          cellsToUpdate: _clearDefeatedCells(nation),
        ),
      null => MovingInProgress(isVictory: false, defeated: null, cellsToUpdate: [])
    };
  }

  Iterable<GameFieldCellRead> _clearDefeatedCells(Nation defeatedNation) {
    final result = <GameFieldCellRead>[];

    for (final cell in _gameField.cells) {
      if (cell.nation != defeatedNation) {
        continue;
      }

      cell.clear();

      result.add(cell);
    }

    return result;
  }
}
