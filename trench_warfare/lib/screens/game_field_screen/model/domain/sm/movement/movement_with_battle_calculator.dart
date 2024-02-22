part of movement;

class MovementWithBattleCalculator extends MovementCalculator {
  MovementWithBattleCalculator({
    required super.gameField,
    required super.nation,
    required super.updateGameObjectsEvent,
  });

  @override
  State startMovement(Iterable<GameFieldCell> path) {
    final attackingUnit = path.first.removeActiveUnit();

    final reachableCells = path.where((e) => e.pathItem != null && e.pathItem!.isActive).toList();

    final defendingCell = reachableCells[reachableCells.length - 1];
    final attackingCell = reachableCells[reachableCells.length - 2];

    final defendingUnit = defendingCell.activeUnit!;

    // The battle calculation
    final battleResult = _calculateBattleResult(attackingUnit, attackingCell: attackingCell, defendingCell: defendingCell);

    // set nations to the cells up to the attacking cell
    for (var i = 0; i <= reachableCells.length - 2; i++) {
      reachableCells[i].setNation(_nation);
    }

    // Update the defending cell
    if (battleResult.isDefendingCellTerrainModifierDestroyed) {
      defendingCell.setTerrainModifier(null);
    }

    if (battleResult.isDefendingCellProductionCenterDestroyed) {
      defendingCell.setProductionCenter(null);
    } else if (battleResult.defendingCellProductionCenterNewLevel != null) {
      defendingCell.productionCenter?.setLevel(battleResult.defendingCellProductionCenterNewLevel!);
    }

    // Update the units' state
    if (battleResult.attackingUnit is Died && battleResult.defendingUnit is Died) {
      defendingCell.removeActiveUnit();
    }

    if (battleResult.attackingUnit is Died && battleResult.defendingUnit is Alive) {
      _updateUnit(defendingCell.activeUnit!, (battleResult.defendingUnit as Alive).info);
    }

    if (battleResult.attackingUnit is Died && battleResult.defendingUnit is InPanic) {
      _updateUnit(defendingCell.activeUnit!, (battleResult.defendingUnit as InPanic).info);

      if (battleResult.defendingUnitCellId != defendingCell.id) {
        final newCell = _gameField.getCellById(battleResult.defendingUnitCellId!);
        newCell.addUnitAsActive(defendingCell.removeActiveUnit());
      }
    }

    if (battleResult.attackingUnit is Alive && battleResult.defendingUnit is Died) {
      defendingCell.removeActiveUnit();

      _updateUnit(attackingUnit, (battleResult.attackingUnit as Alive).info);

      final newAttackingUnitCell = battleResult.attackingUnitCellId == attackingCell.id ? attackingCell : defendingCell;

      newAttackingUnitCell.setNation(_nation);

      _addAttackingUnitToCell(attackingUnit, newAttackingUnitCell: newAttackingUnitCell, defendingCell:  defendingCell);
    }

    if (battleResult.attackingUnit is Alive && battleResult.defendingUnit is Alive) {
      _updateUnit(attackingUnit, (battleResult.attackingUnit as Alive).info);
      _updateUnit(defendingCell.activeUnit!, (battleResult.defendingUnit as Alive).info);

      _addAttackingUnitToCell(attackingUnit, newAttackingUnitCell: attackingCell, defendingCell: defendingCell);
    }

    if (battleResult.attackingUnit is Alive && battleResult.defendingUnit is InPanic) {
      _updateUnit(attackingUnit, (battleResult.attackingUnit as Alive).info);
      _updateUnit(defendingCell.activeUnit!, (battleResult.defendingUnit as InPanic).info);

      if (battleResult.defendingUnitCellId != defendingCell.id) {
        final newDefendingUnitCell = _gameField.getCellById(battleResult.defendingUnitCellId!);
        newDefendingUnitCell.addUnitAsActive(defendingCell.removeActiveUnit());
      }

      final newAttackingUnitCell = battleResult.attackingUnitCellId == attackingCell.id ? attackingCell : defendingCell;

      newAttackingUnitCell.setNation(_nation);

      _addAttackingUnitToCell(attackingUnit, newAttackingUnitCell: newAttackingUnitCell, defendingCell:  defendingCell);
    }

    // Remove calculated path
    for (var cell in path) {
      cell.setPathItem(null);
    }

    _updateUI(
      path: path,
      reachableCells: reachableCells,
      attackingUnit: attackingUnit,
      defendingUnit: defendingUnit,
      attackingCell: attackingCell,
      defendingCell: defendingCell,
    );

    return MovingInProgress();
  }

  BattleResult _calculateBattleResult(
    Unit attackingUnit, {
    required GameFieldCell attackingCell,
    required GameFieldCell defendingCell,
  }) {
    final rawBattleResult = UnitsBattleCalculator.calculateBattle(attacking: attackingUnit, defendingCell: defendingCell);

    final battleResult = BattleResultCalculator(_gameField).calculateBattle(
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

  void _addAttackingUnitToCell(
    Unit attackingUnit, {
    required GameFieldCell newAttackingUnitCell,
    required GameFieldCell defendingCell,
  }) {
    newAttackingUnitCell.addUnitAsActive(attackingUnit);

    // We must update the movement points based on defending cell - to reduce the movement points after every attack
    attackingUnit.setMovementPoints(defendingCell.pathItem!.movementPointsLeft);

    if (attackingUnit.movementPoints > 0) {
      final state =
          _canMove(startCell: newAttackingUnitCell, isLandUnit: attackingUnit.isLand) ? UnitState.enabled : UnitState.disabled;
      attackingUnit.setState(state);
    } else {
      attackingUnit.setState(UnitState.disabled);
    }
  }

  void _updateUI({
    required Iterable<GameFieldCell> path,
    required List<GameFieldCell> reachableCells,
    required GameFieldCell attackingCell,
    required GameFieldCell defendingCell,
    required Unit attackingUnit,
    required Unit defendingUnit,
  }) {
    // Remove the attacking troop from the cell and show it as a separate unit
    var updateEvents = [
      CreateUntiedUnit(path.first, attackingUnit),
      UpdateObject(path.first),
    ];

    // Move the attacking unit to the attack cell
    final pathBeforeBattle = reachableCells.take(reachableCells.length - 1);
    GameFieldCell? priorCell;
    for (var cell in pathBeforeBattle) {
      if (cell != pathBeforeBattle.first) {
        updateEvents.add(MoveUntiedUnit(
          startCell: priorCell!,
          endCell: cell,
          unit: attackingUnit,
          time: MovementConstants.unitMovementTime,
        ));
        updateEvents.add(UpdateObject(cell));
        updateEvents.add(Pause(MovementConstants.unitMovementPause));
      }
      priorCell = cell;
    }

    final attackingDamageType = attackingUnit.isMechanical ? DamageType.explosion : DamageType.bloodSplash;
    final defendingDamageType = defendingUnit.isMechanical ? DamageType.explosion : DamageType.bloodSplash;

    // Show damage - case 1 - simultaneously
    if (!attackingUnit.hasArtillery && !defendingUnit.hasArtillery) {
      updateEvents.add(ShowDualDamage(
        cell1: attackingCell,
        damageType1: attackingDamageType,
        cell2: defendingCell,
        damageType2: defendingDamageType,
        time: MovementConstants.damageAnimationTime,
      ));
    }

    // Show damage - case 2 - the defending unit doesn't strike back
    if (attackingUnit.hasArtillery && !defendingUnit.hasArtillery) {
      updateEvents.add(ShowDamage(
        cell: defendingCell,
        damageType: defendingDamageType,
        time: MovementConstants.damageAnimationTime,
      ));
    }

    // Show damage - case 3 - the attacking artillery strikes first, then the defending troop fires back.
    if (attackingUnit.hasArtillery && defendingUnit.hasArtillery) {
      updateEvents.add(ShowDamage(
        cell: defendingCell,
        damageType: defendingDamageType,
        time: MovementConstants.damageAnimationTime,
      ));

      updateEvents.add(ShowDamage(
        cell: attackingCell,
        damageType: attackingDamageType,
        time: MovementConstants.damageAnimationTime,
      ));
    }

    // Show damage - case 4 - the defending artillery strikes first, and the attacking troop strikes in the second place
    if (!attackingUnit.hasArtillery && defendingUnit.hasArtillery) {
      updateEvents.add(ShowDamage(
        cell: attackingCell,
        damageType: attackingDamageType,
        time: MovementConstants.damageAnimationTime,
      ));

      updateEvents.add(ShowDamage(
        cell: defendingCell,
        damageType: defendingDamageType,
        time: MovementConstants.damageAnimationTime,
      ));
    }

    // Remove the attacking troop as a separate unit
    updateEvents.add(RemoveUntiedUnit(attackingUnit));

    // Update the defending cell
    updateEvents.add(UpdateObject(reachableCells.last));

    // Update cells in an inactive part of the path
    for (var cell in path) {
      if (!reachableCells.contains(cell)) {
        updateEvents.add(UpdateObject(cell));
      }
    }

    updateEvents.add(MovementCompleted());
    _updateGameObjectsEvent.update(updateEvents);
  }
}
