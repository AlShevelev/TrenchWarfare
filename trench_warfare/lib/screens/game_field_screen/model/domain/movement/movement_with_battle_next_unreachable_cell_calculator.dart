part of movement;

class MovementWithBattleNextUnreachableCell extends MovementCalculator {
  MovementWithBattleNextUnreachableCell({
    required super.gameField,
    required super.nation,
    required super.updateGameObjectsEvent,
    required super.gameOverConditionsCalculator,
  });

  @override
  State startMovement(Iterable<GameFieldCell> path) {
    final attackingUnit = _detachActiveUnit(path);

    final reachableCells = path.where((e) => e.pathItem != null && e.pathItem!.isActive).toList();

    final defendingCell = path.last;
    final attackingCell = path.first;

    final defendingUnit = defendingCell.activeUnit!;

    Logger.info(
      'BATTLE_WITH_UNREACHABLE; from: ${path.first}; to: ${path.last}; total: ${path.length}; '
      'attackingUnit: $attackingUnit; defendingUnit: $defendingUnit; '
      'attackingCell: $attackingCell; defendingCell: $defendingCell',
      tag: 'MOVEMENT',
    );

    // The battle calculation
    final battleResult =
        _calculateBattleResult(attackingUnit, attackingCell: attackingCell, defendingCell: defendingCell);

    Logger.info('BATTLE_WITH_UNREACHABLE; result: $battleResult', tag: 'MOVEMENT');

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
    GameFieldCell? newDefendingUnitCell;
    if (battleResult.attackingUnit is Died && battleResult.defendingUnit is Died) {
      defendingCell.removeActiveUnit();
    }

    if (battleResult.attackingUnit is Died && battleResult.defendingUnit is Alive) {
      _updateUnit(defendingUnit, (battleResult.defendingUnit as Alive).info, resetMovementPoints: false);
    }

    if (battleResult.attackingUnit is Died && battleResult.defendingUnit is InPanic) {
      _updateUnit(defendingUnit, (battleResult.defendingUnit as InPanic).info, resetMovementPoints: false);

      if (battleResult.defendingUnitCellId != defendingCell.id) {
        newDefendingUnitCell = _gameField.getCellById(battleResult.defendingUnitCellId!);
        newDefendingUnitCell.addUnitAsActive(defendingCell.removeActiveUnit());
      }
    }

    if (battleResult.attackingUnit is Alive && battleResult.defendingUnit is Died) {
      defendingCell.removeActiveUnit();

      _updateUnit(attackingUnit, (battleResult.attackingUnit as Alive).info, resetMovementPoints: true);

      _addAttackingUnitToCell(attackingUnit, attackingCell);
    }

    if (battleResult.attackingUnit is Alive && battleResult.defendingUnit is Alive) {
      _updateUnit(attackingUnit, (battleResult.attackingUnit as Alive).info, resetMovementPoints: true);
      _updateUnit(defendingUnit, (battleResult.defendingUnit as Alive).info, resetMovementPoints: false);

      _addAttackingUnitToCell(attackingUnit, attackingCell);
    }

    if (battleResult.attackingUnit is Alive && battleResult.defendingUnit is InPanic) {
      _updateUnit(attackingUnit, (battleResult.attackingUnit as Alive).info, resetMovementPoints: true);
      _updateUnit(defendingUnit, (battleResult.defendingUnit as InPanic).info, resetMovementPoints: false);

      if (battleResult.defendingUnitCellId != defendingCell.id) {
        newDefendingUnitCell = _gameField.getCellById(battleResult.defendingUnitCellId!);
        newDefendingUnitCell.addUnitAsActive(defendingCell.removeActiveUnit());
      }

      _addAttackingUnitToCell(attackingUnit, attackingCell);
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
      newDefendingUnitCell: newDefendingUnitCell,
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

    final battleResult = BattleResultCalculator(_gameField).calculateBattle(
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
  }

  void _updateUI({
    required Iterable<GameFieldCell> path,
    required List<GameFieldCell> reachableCells,
    required GameFieldCell attackingCell,
    required GameFieldCell defendingCell,
    GameFieldCell? newDefendingUnitCell,
    required Unit attackingUnit,
    required Unit defendingUnit,
  }) {
    // Remove the attacking troop from the cell and show it as a separate unit
    var updateEvents = [
      CreateUntiedUnit(path.first, attackingUnit),
      UpdateCell(path.first),
    ];

    final attackingDamageType = attackingUnit.isMechanical ? DamageType.explosion : DamageType.bloodSplash;
    final defendingDamageType = defendingUnit.isMechanical ? DamageType.explosion : DamageType.bloodSplash;

    // Show damage - case 2 - the defending unit doesn't strike back
    if (attackingUnit.hasArtillery && !defendingUnit.hasArtillery) {
      updateEvents.add(ShowDamage(
        cell: defendingCell,
        damageType: defendingDamageType,
        time: AnimationConstants.damageAnimationTime,
      ));
    }

    // Show damage - case 3 - the attacking artillery strikes first, then the defending troop fires back.
    if (attackingUnit.hasArtillery && defendingUnit.hasArtillery) {
      updateEvents.add(ShowDamage(
        cell: defendingCell,
        damageType: defendingDamageType,
        time: AnimationConstants.damageAnimationTime,
      ));

      updateEvents.add(ShowDamage(
        cell: attackingCell,
        damageType: attackingDamageType,
        time: AnimationConstants.damageAnimationTime,
      ));
    }

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
      updateEvents.add(UpdateCell(
        newDefendingUnitCell,
        updateBorderCells: _gameField.findCellsAround(newDefendingUnitCell),
      ));
    }

    // Update cells in an inactive part of the path
    for (var cell in path) {
      if (!reachableCells.contains(cell)) {
        updateEvents.add(UpdateCell(cell));
      }
    }

    updateEvents.add(AnimationCompleted());
    _updateGameObjectsEvent.update(updateEvents);
  }
}
