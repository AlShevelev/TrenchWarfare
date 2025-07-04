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

class MovementWithBattleNextUnreachableCell extends MovementCalculator with ShowDamageCalculator {
  MovementWithBattleNextUnreachableCell({
    required super.gameField,
    required super.myNation,
    required super.humanNation,
    required super.updateGameObjectsEvent,
    required super.gameOverConditionsCalculator,
    required super.animationTime,
    required super.unitUpdateResultBridge,
    required super.pathFacade,
  });

  @override
  State startMovement(Iterable<GameFieldCell> path) {
    final defendingCell = path.last;
    final attackingCell = path.first;

    final startUnit = attackingCell.activeUnit!;

    final detachResult = _detachActiveUnit(path);

    final reachableCells = path.where((e) => e.pathItem != null && e.pathItem!.isActive).toList();

    final defendingUnit = defendingCell.activeUnit!;

    final enemyNation = defendingCell.nation!;

    _unitUpdateResultBridge?.addBefore(
      nation: _myNation,
      unit: Unit.copy(startUnit),
      cell: attackingCell,
    );

    _unitUpdateResultBridge?.addBefore(
      nation: enemyNation,
      unit: Unit.copy(defendingUnit),
      cell: defendingCell,
    );

    Logger.info(
      'BATTLE_WITH_UNREACHABLE; from: ${path.first}; to: ${path.last}; total: ${path.length}; '
      'attackingUnit: ${detachResult.unit}; defendingUnit: $defendingUnit; '
      'attackingCell: $attackingCell; defendingCell: $defendingCell',
      tag: 'MOVEMENT',
    );

    // The battle calculation
    final battleResult =
        _calculateBattleResult(detachResult.unit, attackingCell: attackingCell, defendingCell: defendingCell);

    Logger.info('BATTLE_WITH_UNREACHABLE; result: $battleResult', tag: 'MOVEMENT');

    // Update the defending cell
    if (battleResult.isDefendingCellTerrainModifierDestroyed) {
      defendingCell.setTerrainModifier(null);
    }

    if (battleResult.defendingCellProductionCenterNewLevel != null) {
      defendingCell.productionCenter?.setLevel(battleResult.defendingCellProductionCenterNewLevel!);
    }

    // Update the units' state
    GameFieldCell? newDefendingUnitCell;
    if (battleResult.attackingUnit is Died && battleResult.defendingUnit is Died) {
      defendingCell.removeActiveUnit();

      if (detachResult.detachedFrom != null) {
        _unitUpdateResultBridge?.addAfter(
          nation: _myNation,
          unit: Unit.copy(detachResult.detachedFrom!),
          cell: attackingCell,
        );
      }
    }

    if (battleResult.attackingUnit is Died && battleResult.defendingUnit is Alive) {
      _updateUnit(defendingUnit, (battleResult.defendingUnit as Alive).info, resetMovementPoints: false);

      if (detachResult.detachedFrom != null) {
        _unitUpdateResultBridge?.addAfter(
          nation: _myNation,
          unit: Unit.copy(detachResult.detachedFrom!),
          cell: attackingCell,
        );
      }

      _unitUpdateResultBridge?.addAfter(
        nation: enemyNation,
        unit: Unit.copy(defendingUnit),
        cell: defendingCell,
      );
    }

    if (battleResult.attackingUnit is Died && battleResult.defendingUnit is InPanic) {
      _updateUnit(defendingUnit, (battleResult.defendingUnit as InPanic).info, resetMovementPoints: false);

      if (battleResult.defendingUnitCellId != defendingCell.id) {
        newDefendingUnitCell = _gameField.getCellById(battleResult.defendingUnitCellId!);
        newDefendingUnitCell.addUnitAsActive(defendingCell.removeActiveUnit());
      }

      if (detachResult.detachedFrom != null) {
        _unitUpdateResultBridge?.addAfter(
          nation: _myNation,
          unit: Unit.copy(detachResult.detachedFrom!),
          cell: attackingCell,
        );
      }

      _unitUpdateResultBridge?.addAfter(
        nation: enemyNation,
        unit: Unit.copy(defendingUnit),
        cell: newDefendingUnitCell ?? defendingCell,
      );
    }

    if (battleResult.attackingUnit is Alive && battleResult.defendingUnit is Died) {
      defendingCell.removeActiveUnit();

      _updateUnit(detachResult.unit, (battleResult.attackingUnit as Alive).info, resetMovementPoints: true);

      _addAttackingUnitToCell(detachResult.unit, attackingCell);

      _unitUpdateResultBridge?.addAfter(
        nation: _myNation,
        unit: Unit.copy(detachResult.detachedFrom ?? detachResult.unit),
        cell: attackingCell,
      );
    }

    if (battleResult.attackingUnit is Alive && battleResult.defendingUnit is Alive) {
      _updateUnit(detachResult.unit, (battleResult.attackingUnit as Alive).info, resetMovementPoints: true);
      _updateUnit(defendingUnit, (battleResult.defendingUnit as Alive).info, resetMovementPoints: false);

      _addAttackingUnitToCell(detachResult.unit, attackingCell);

      _unitUpdateResultBridge?.addAfter(
        nation: _myNation,
        unit: Unit.copy(detachResult.detachedFrom ?? detachResult.unit),
        cell: attackingCell,
      );

      _unitUpdateResultBridge?.addAfter(
        nation: enemyNation,
        unit: Unit.copy(defendingUnit),
        cell: defendingCell,
      );
    }

    if (battleResult.attackingUnit is Alive && battleResult.defendingUnit is InPanic) {
      _updateUnit(detachResult.unit, (battleResult.attackingUnit as Alive).info, resetMovementPoints: true);
      _updateUnit(defendingUnit, (battleResult.defendingUnit as InPanic).info, resetMovementPoints: false);

      if (battleResult.defendingUnitCellId != defendingCell.id) {
        newDefendingUnitCell = _gameField.getCellById(battleResult.defendingUnitCellId!);
        newDefendingUnitCell.addUnitAsActive(defendingCell.removeActiveUnit());
      }

      _addAttackingUnitToCell(detachResult.unit, attackingCell);

      _unitUpdateResultBridge?.addAfter(
        nation: _myNation,
        unit: Unit.copy(detachResult.detachedFrom ?? detachResult.unit),
        cell: attackingCell,
      );

      _unitUpdateResultBridge?.addAfter(
        nation: enemyNation,
        unit: Unit.copy(defendingUnit),
        cell: newDefendingUnitCell ?? defendingCell,
      );
    }

    // Collect dead units
    final deadUnits = <Unit>[];
    if (battleResult.attackingUnit is Died) {
      deadUnits.add(detachResult.unit);
    }
    if (battleResult.defendingUnit is Died) {
      deadUnits.add(defendingUnit);
    }

    // Remove calculated path
    for (var cell in path) {
      cell.setPathItem(null);
    }

    _updateUI(
      path: path,
      reachableCells: reachableCells,
      attackingUnit: detachResult.unit,
      defendingUnit: defendingUnit,
      attackingCell: attackingCell,
      defendingCell: defendingCell,
      newDefendingUnitCell: newDefendingUnitCell,
      deadUnits: deadUnits,
    );

    return _getNextState();
  }

  BattleResult _calculateBattleResult(
    Unit attackingUnit, {
    required GameFieldCell attackingCell,
    required GameFieldCell defendingCell,
  }) {
    final rawBattleResult =
        UnitsBattleCalculator.calculateBattle(attacking: attackingUnit, defendingCell: defendingCell);

    final battleResult = BattleResultCalculator(_pathFacade).calculateBattle(
      attackingCell: attackingCell,
      defendingCell: defendingCell,
      battleResult: rawBattleResult,
    );

    return battleResult;
  }

  void _updateUnit(Unit unitToUpdate, UnitInBattle updateInfo, {required bool resetMovementPoints}) {
    unitToUpdate.setHealth(updateInfo.health);
    unitToUpdate.setTookPartInBattles(updateInfo.tookPartInBattles);
    unitToUpdate.setFatigue(updateInfo.fatigue);

    if (resetMovementPoints) {
      unitToUpdate.setMovementPoints(0);
    }
  }

  void _addAttackingUnitToCell(Unit attackingUnit, GameFieldCell attackingUnitCell) {
    attackingUnitCell.addUnitAsActive(attackingUnit);
    attackingUnit.setState(attackingUnit.movementPoints == 0 ? UnitState.disabled : UnitState.enabled);

    if (attackingUnit.state == UnitState.disabled) {
      attackingUnitCell.makeActiveUnitLast();
    }
  }

  void _updateUI({
    required Iterable<GameFieldCell> path,
    required List<GameFieldCell> reachableCells,
    required GameFieldCell attackingCell,
    required GameFieldCell defendingCell,
    GameFieldCell? newDefendingUnitCell,
    required Unit attackingUnit,
    required Unit defendingUnit,
    required List<Unit> deadUnits,
  }) {
    // Remove the attacking troop from the cell and show it as a separate unit
    var updateEvents = [
      CreateUntiedUnit(path.first, attackingUnit),
      UpdateCell(path.first, updateBorderCells: []),
      MoveCameraToCell(path.first),
    ];

    final damageEvents = calculateDamageEvents(
      attackingCell: attackingCell,
      defendingCell: defendingCell,
      attackingUnit: attackingUnit,
      defendingUnit: defendingUnit,
      deadUnits: deadUnits,
      animationTime: _animationTime,
    );
    updateEvents.addAll(damageEvents);

    // Remove the attacking troop as a separate unit
    updateEvents.add(RemoveUntiedUnit(attackingUnit));

    // Update the defending cell
    updateEvents.add(
      UpdateCell(
        reachableCells.last,
        updateBorderCells: _gameField.findCellsAround(reachableCells.last),
      ),
    );

    if (newDefendingUnitCell != null) {
      updateEvents.add(UpdateCell(newDefendingUnitCell,
          updateBorderCells: _gameField.findCellsAround(newDefendingUnitCell)));
    }

    // Update cells in an inactive part of the path
    for (var cell in path) {
      if (!reachableCells.contains(cell)) {
        updateEvents.add(UpdateCell(cell, updateBorderCells: []));
      }
    }

    updateEvents.add(AnimationCompleted());
    _updateGameObjectsEvent.update(updateEvents);
  }
}
