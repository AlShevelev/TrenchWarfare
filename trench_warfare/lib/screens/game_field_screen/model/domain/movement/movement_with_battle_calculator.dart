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

class MovementWithBattleCalculator extends MovementCalculator with ShowDamageCalculator {
  MovementWithBattleCalculator({
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
    final startUnit = path.first.activeUnit!;

    final detachResult = _detachActiveUnit(path);

    final reachableCells = path.where((e) => e.pathItem != null && e.pathItem!.isActive).toList();

    final defendingCell = reachableCells[reachableCells.length - 1];
    final attackingCell = reachableCells[reachableCells.length - 2];

    final defendingUnit = defendingCell.activeUnit!;

    final enemyNation = defendingCell.nation!;

    _unitUpdateResultBridge?.addBefore(
      nation: _myNation,
      unit: Unit.copy(startUnit),
      cell: path.first,
    );

    _unitUpdateResultBridge?.addBefore(
      nation: enemyNation,
      unit: Unit.copy(defendingUnit),
      cell: defendingCell,
    );

    Logger.info(
      'BATTLE; from: ${path.first}; to: ${path.last}; total: ${path.length}; '
      'attackingUnit: ${detachResult.unit}; defendingUnit: $defendingUnit; '
      'attackingCell: $attackingCell; defendingCell: $defendingCell',
      tag: 'MOVEMENT',
    );

    // The battle calculation
    final battleResult = _calculateBattleResult(
      detachResult.unit,
      attackingCell: attackingCell,
      defendingCell: defendingCell,
    );

    Logger.info('BATTLE; result: $battleResult', tag: 'MOVEMENT');

    // set nations to the cells up to the attacking cell
    for (var i = 0; i <= reachableCells.length - 2; i++) {
      reachableCells[i].setNation(_myNation);
    }

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
          cell: path.first,
        );
      }
    }

    if (battleResult.attackingUnit is Died && battleResult.defendingUnit is Alive) {
      _updateUnit(defendingUnit, (battleResult.defendingUnit as Alive).info);

      if (detachResult.detachedFrom != null) {
        _unitUpdateResultBridge?.addAfter(
          nation: _myNation,
          unit: Unit.copy(detachResult.detachedFrom!),
          cell: path.first,
        );
      }

      _unitUpdateResultBridge?.addAfter(
        nation: enemyNation,
        unit: Unit.copy(defendingUnit),
        cell: defendingCell,
      );
    }

    if (battleResult.attackingUnit is Died && battleResult.defendingUnit is InPanic) {
      _updateUnit(defendingUnit, (battleResult.defendingUnit as InPanic).info);

      if (battleResult.defendingUnitCellId != defendingCell.id) {
        newDefendingUnitCell = _gameField.getCellById(battleResult.defendingUnitCellId!);
        newDefendingUnitCell.addUnitAsActive(defendingCell.removeActiveUnit());
      }

      if (detachResult.detachedFrom != null) {
        _unitUpdateResultBridge?.addAfter(
          nation: _myNation,
          unit: Unit.copy(detachResult.detachedFrom!),
          cell: path.first,
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

      _updateUnit(detachResult.unit, (battleResult.attackingUnit as Alive).info);

      final newAttackingUnitCell =
          battleResult.attackingUnitCellId == attackingCell.id ? attackingCell : defendingCell;

      newAttackingUnitCell.setNation(_myNation);

      _addAttackingUnitToCell(
        attackingUnit: detachResult.unit,
        startUnit: startUnit,
        newAttackingUnitCell: newAttackingUnitCell,
        oldAttackingCell: attackingCell,
        defendingCell: defendingCell,
      );

      if (detachResult.detachedFrom != null) {
        _unitUpdateResultBridge?.addAfter(
          nation: _myNation,
          unit: Unit.copy(detachResult.detachedFrom!),
          cell: path.first,
        );
      }

      _unitUpdateResultBridge?.addAfter(
        nation: _myNation,
        unit: Unit.copy(detachResult.unit),
        cell: newAttackingUnitCell,
      );
    }

    if (battleResult.attackingUnit is Alive && battleResult.defendingUnit is Alive) {
      _updateUnit(detachResult.unit, (battleResult.attackingUnit as Alive).info);
      _updateUnit(defendingUnit, (battleResult.defendingUnit as Alive).info);

      _addAttackingUnitToCell(
        attackingUnit: detachResult.unit,
        startUnit: startUnit,
        newAttackingUnitCell: attackingCell,
        oldAttackingCell: attackingCell,
        defendingCell: defendingCell,
      );

      if (detachResult.detachedFrom != null) {
        _unitUpdateResultBridge?.addAfter(
          nation: _myNation,
          unit: Unit.copy(detachResult.detachedFrom!),
          cell: path.first,
        );
      }

      _unitUpdateResultBridge?.addAfter(
        nation: _myNation,
        unit: Unit.copy(detachResult.unit),
        cell: attackingCell,
      );

      _unitUpdateResultBridge?.addAfter(
        nation: enemyNation,
        unit: Unit.copy(defendingUnit),
        cell: defendingCell,
      );
    }

    if (battleResult.attackingUnit is Alive && battleResult.defendingUnit is InPanic) {
      _updateUnit(detachResult.unit, (battleResult.attackingUnit as Alive).info);
      _updateUnit(defendingUnit, (battleResult.defendingUnit as InPanic).info);

      if (battleResult.defendingUnitCellId != defendingCell.id) {
        newDefendingUnitCell = _gameField.getCellById(battleResult.defendingUnitCellId!);
        newDefendingUnitCell.addUnitAsActive(defendingCell.removeActiveUnit());
      }

      final newAttackingUnitCell =
          battleResult.attackingUnitCellId == attackingCell.id ? attackingCell : defendingCell;

      newAttackingUnitCell.setNation(_myNation);

      _addAttackingUnitToCell(
        attackingUnit: detachResult.unit,
        startUnit: startUnit,
        newAttackingUnitCell: newAttackingUnitCell,
        oldAttackingCell: attackingCell,
        defendingCell: defendingCell,
      );

      if (detachResult.detachedFrom != null) {
        _unitUpdateResultBridge?.addAfter(
          nation: _myNation,
          unit: Unit.copy(detachResult.detachedFrom!),
          cell: path.first,
        );
      }

      _unitUpdateResultBridge?.addAfter(
        nation: _myNation,
        unit: Unit.copy(detachResult.unit),
        cell: newAttackingUnitCell,
      );

      _unitUpdateResultBridge?.addAfter(
        nation: enemyNation,
        unit: Unit.copy(defendingUnit),
        cell: newDefendingUnitCell ?? defendingCell,
      );
    }

    // Remove calculated path
    for (var cell in path) {
      cell.setPathItem(null);
    }

    // Collect dead units
    final deadUnits = <Unit>[];
    if (battleResult.attackingUnit is Died) {
      deadUnits.add(detachResult.unit);
    }
    if (battleResult.defendingUnit is Died) {
      deadUnits.add(defendingUnit);
    }

    _updateUI(
      path: path,
      reachableCells: reachableCells,
      attackingUnit: detachResult.unit,
      defendingUnit: defendingUnit,
      attackingCell: attackingCell,
      defendingCell: defendingCell,
      pcCaptured: battleResult.defendingCellProductionCenterNewLevel != null,
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

  void _updateUnit(Unit unitToUpdate, UnitInBattle updateInfo) {
    unitToUpdate.setHealth(updateInfo.health);
    unitToUpdate.setTookPartInBattles(updateInfo.tookPartInBattles);
    unitToUpdate.setFatigue(updateInfo.fatigue);
  }

  void _addAttackingUnitToCell({
    required Unit attackingUnit,
    required Unit startUnit,
    required GameFieldCell oldAttackingCell,
    required GameFieldCell newAttackingUnitCell,
    required GameFieldCell defendingCell,
  }) {
    // We must update the movement points based on defending cell - to reduce the movement points after every attack
    attackingUnit.setMovementPoints(defendingCell.pathItem!.movementPointsLeft);

    if (attackingUnit.movementPoints > 0) {
      final state = _canMoveForUnit(startCell: newAttackingUnitCell, unit: attackingUnit)
          ? UnitState.enabled
          : UnitState.disabled;
      attackingUnit.setState(state);
    } else {
      attackingUnit.setState(UnitState.disabled);
    }

    if (startUnit is Carrier && oldAttackingCell.id == newAttackingUnitCell.id) {
      startUnit.addUnitAsActive(attackingUnit);
    } else {
      newAttackingUnitCell.addUnitAsActive(attackingUnit);
      if (attackingUnit.state == UnitState.disabled) {
        newAttackingUnitCell.makeActiveUnitLast();
      }
    }
  }

  void _updateUI({
    required Iterable<GameFieldCell> path,
    required List<GameFieldCell> reachableCells,
    required GameFieldCell attackingCell,
    required GameFieldCell defendingCell,
    required GameFieldCell? newDefendingUnitCell,
    required bool pcCaptured,
    required Unit attackingUnit,
    required Unit defendingUnit,
    required List<Unit> deadUnits,
  }) {
    // Remove the attacking troop from the cell and show it as a separate unit
    var updateEvents = [
      CreateUntiedUnit(path.first, attackingUnit),
      UpdateCell(path.first, updateBorderCells: []),
    ];

    // Move the attacking unit to the attack cell
    final pathBeforeBattle = reachableCells.take(reachableCells.length - 1);
    GameFieldCell? priorCell;
    for (var cell in pathBeforeBattle) {
      updateEvents.add(MoveCameraToCell(cell));
      if (cell != pathBeforeBattle.first) {
        updateEvents.add(MoveUntiedUnit(
          startCell: priorCell!,
          endCell: cell,
          unit: attackingUnit,
          time: _animationTime.unitMovementTime,
        ));
        updateEvents.add(UpdateCell(priorCell, updateBorderCells: _gameField.findCellsAround(priorCell)));
        updateEvents.add(Pause(_animationTime.unitMovementPause));
      }
      priorCell = cell;
    }


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

    updateEvents.add(UpdateCell(
      reachableCells.last,
      updateBorderCells: _gameField.findCellsAround(reachableCells.last),
    ));

    if (pcCaptured) {
      updateEvents.add(PlaySound(
        type: SoundType.battleResultPcCaptured,
        strategy: SoundStrategy.putToQueue,
      ));
    }

    // Update the defending cell
    updateEvents.add(
        UpdateCell(reachableCells.last, updateBorderCells: _gameField.findCellsAround(reachableCells.last)));

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
