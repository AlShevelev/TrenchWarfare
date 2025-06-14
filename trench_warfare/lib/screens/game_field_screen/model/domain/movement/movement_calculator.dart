/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of movement;

class _DetachActiveUnitResult {
  final Carrier? detachedFrom;

  final Unit unit;

  _DetachActiveUnitResult({required this.detachedFrom, required this.unit});
}

abstract class MovementCalculator {
  @protected
  final GameFieldRead _gameField;

  @protected
  final Nation _myNation;

  final Nation _humanNation;

  @protected
  final SingleStream<Iterable<UpdateGameEvent>> _updateGameObjectsEvent;

  @protected
  final PathFacade _pathFacade;

  @protected
  final GameOverConditionsCalculator _gameOverConditionsCalculator;

  @protected
  final AnimationTime _animationTime;

  @protected
  final UnitUpdateResultBridge? _unitUpdateResultBridge;

  MovementCalculator({
    required GameFieldRead gameField,
    required Nation myNation,
    required Nation humanNation,
    required SingleStream<Iterable<UpdateGameEvent>> updateGameObjectsEvent,
    required GameOverConditionsCalculator gameOverConditionsCalculator,
    required AnimationTime animationTime,
    required UnitUpdateResultBridge? unitUpdateResultBridge,
    required PathFacade pathFacade,
  })  : _gameField = gameField,
        _myNation = myNation,
        _humanNation = humanNation,
        _updateGameObjectsEvent = updateGameObjectsEvent,
        _pathFacade = pathFacade,
        _gameOverConditionsCalculator = gameOverConditionsCalculator,
        _animationTime = animationTime,
        _unitUpdateResultBridge = unitUpdateResultBridge;

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
  _DetachActiveUnitResult _detachActiveUnit(Iterable<GameFieldCell> path) {
    final activeUnit = path.first.activeUnit!;
    final secondPathCell = path.elementAt(1);

    if (activeUnit is Carrier && secondPathCell.isLand && !secondPathCell.hasRiver) {
      activeUnit.setState(UnitState.enabled);

      final detachedUnit = activeUnit.removeActiveUnit();
      return _DetachActiveUnitResult(detachedFrom: activeUnit, unit: detachedUnit);
    } else {
      final detachedUnit = path.first.removeActiveUnit();
      return _DetachActiveUnitResult(detachedFrom: null, unit: detachedUnit);
    }
  }

  @protected
  void _attachUnitAsActive(GameFieldCell cell, Unit unit) {
    if (cell.activeUnit is Carrier && unit.isLand) {
      (cell.activeUnit as Carrier).addUnitAsActive(unit);
    } else {
      cell.addUnitAsActive(unit);
    }
  }

  State _getNextState() {
    final gameOverConditions = _gameOverConditionsCalculator.calculate(
      myNation: _myNation,
      humanNation: _humanNation,
    );

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
