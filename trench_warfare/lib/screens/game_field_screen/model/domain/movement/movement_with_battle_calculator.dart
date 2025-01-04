part of movement;

class MovementWithBattleCalculator extends MovementCalculator {
  MovementWithBattleCalculator({
    required super.gameField,
    required super.nation,
    required super.updateGameObjectsEvent,
    required super.gameOverConditionsCalculator,
    required super.animationTime,
  });

  @override
  State startMovement(Iterable<GameFieldCell> path) {
    final movingUnit = path.first.activeUnit!;

    final attackingUnit = _detachActiveUnit(path);

    final reachableCells = path.where((e) => e.pathItem != null && e.pathItem!.isActive).toList();

    final defendingCell = reachableCells[reachableCells.length - 1];
    final attackingCell = reachableCells[reachableCells.length - 2];

    final defendingUnit = defendingCell.activeUnit!;

    Logger.info(
      'BATTLE; from: ${path.first}; to: ${path.last}; total: ${path.length}; '
      'attackingUnit: $attackingUnit; defendingUnit: $defendingUnit; '
      'attackingCell: $attackingCell; defendingCell: $defendingCell',
      tag: 'MOVEMENT',
    );

    // The battle calculation
    final battleResult = _calculateBattleResult(
      attackingUnit,
      attackingCell: attackingCell,
      defendingCell: defendingCell,
    );

    Logger.info('BATTLE; result: $battleResult', tag: 'MOVEMENT');

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
    GameFieldCell? newDefendingUnitCell;
    if (battleResult.attackingUnit is Died && battleResult.defendingUnit is Died) {
      defendingCell.removeActiveUnit();
    }

    if (battleResult.attackingUnit is Died && battleResult.defendingUnit is Alive) {
      _updateUnit(defendingUnit, (battleResult.defendingUnit as Alive).info);
    }

    if (battleResult.attackingUnit is Died && battleResult.defendingUnit is InPanic) {
      _updateUnit(defendingUnit, (battleResult.defendingUnit as InPanic).info);

      if (battleResult.defendingUnitCellId != defendingCell.id) {
        newDefendingUnitCell = _gameField.getCellById(battleResult.defendingUnitCellId!);
        newDefendingUnitCell.addUnitAsActive(defendingCell.removeActiveUnit());
      }
    }

    if (battleResult.attackingUnit is Alive && battleResult.defendingUnit is Died) {
      defendingCell.removeActiveUnit();

      _updateUnit(attackingUnit, (battleResult.attackingUnit as Alive).info);

      final newAttackingUnitCell =
          battleResult.attackingUnitCellId == attackingCell.id ? attackingCell : defendingCell;

      newAttackingUnitCell.setNation(_nation);

      _addAttackingUnitToCell(
        attackingUnit: attackingUnit,
        movingUnit: movingUnit,
        newAttackingUnitCell: newAttackingUnitCell,
        oldAttackingCell: attackingCell,
        defendingCell: defendingCell,
      );
    }

    if (battleResult.attackingUnit is Alive && battleResult.defendingUnit is Alive) {
      _updateUnit(attackingUnit, (battleResult.attackingUnit as Alive).info);
      _updateUnit(defendingUnit, (battleResult.defendingUnit as Alive).info);

      _addAttackingUnitToCell(
        attackingUnit: attackingUnit,
        movingUnit: movingUnit,
        newAttackingUnitCell: attackingCell,
        oldAttackingCell: attackingCell,
        defendingCell: defendingCell,
      );
    }

    if (battleResult.attackingUnit is Alive && battleResult.defendingUnit is InPanic) {
      _updateUnit(attackingUnit, (battleResult.attackingUnit as Alive).info);
      _updateUnit(defendingUnit, (battleResult.defendingUnit as InPanic).info);

      if (battleResult.defendingUnitCellId != defendingCell.id) {
        newDefendingUnitCell = _gameField.getCellById(battleResult.defendingUnitCellId!);
        newDefendingUnitCell.addUnitAsActive(defendingCell.removeActiveUnit());
      }

      final newAttackingUnitCell =
          battleResult.attackingUnitCellId == attackingCell.id ? attackingCell : defendingCell;

      newAttackingUnitCell.setNation(_nation);

      _addAttackingUnitToCell(
        attackingUnit: attackingUnit,
        movingUnit: movingUnit,
        newAttackingUnitCell: newAttackingUnitCell,
        oldAttackingCell: attackingCell,
        defendingCell: defendingCell,
      );
    }

    // Remove calculated path
    for (var cell in path) {
      cell.setPathItem(null);
    }

    // Collect dead units
    final deadUnits = <Unit>[];
    if (battleResult.attackingUnit is Died) {
      deadUnits.add(attackingUnit);
    }
    if (battleResult.defendingUnit is Died) {
      deadUnits.add(defendingUnit);
    }

    _updateUI(
      path: path,
      reachableCells: reachableCells,
      attackingUnit: attackingUnit,
      defendingUnit: defendingUnit,
      attackingCell: attackingCell,
      defendingCell: defendingCell,
      pcCaptured: battleResult.defendingCellProductionCenterNewLevel != null,
      pcDestroyed: battleResult.isDefendingCellProductionCenterDestroyed,
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

  void _addAttackingUnitToCell({
    required Unit attackingUnit,
    required Unit movingUnit,
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

    if (movingUnit is Carrier && oldAttackingCell.id == newAttackingUnitCell.id) {
      movingUnit.addUnitAsActive(attackingUnit);
    } else {
      newAttackingUnitCell.addUnitAsActive(attackingUnit);
    }
  }

  void _updateUI({
    required Iterable<GameFieldCell> path,
    required List<GameFieldCell> reachableCells,
    required GameFieldCell attackingCell,
    required GameFieldCell defendingCell,
    required GameFieldCell? newDefendingUnitCell,
    required bool pcCaptured,
    required bool pcDestroyed,
    required Unit attackingUnit,
    required Unit defendingUnit,
    required Iterable<Unit> deadUnits,
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
      if (cell != pathBeforeBattle.first) {
        updateEvents.add(MoveCameraToCell(cell));
        updateEvents.add(MoveUntiedUnit(
          startCell: priorCell!,
          endCell: cell,
          unit: attackingUnit,
          time: _animationTime.unitMovementTime,
        ));
        updateEvents.add(UpdateCell(cell, updateBorderCells: _gameField.findCellsAround(cell)));
        updateEvents.add(Pause(_animationTime.unitMovementPause));
      }
      priorCell = cell;
    }

    final attackingDamageType = attackingUnit.isMechanical ? DamageType.explosion : DamageType.bloodSplash;
    final defendingDamageType = defendingUnit.isMechanical ? DamageType.explosion : DamageType.bloodSplash;

    // Show damage - case 1 - simultaneously
    if (!attackingUnit.hasArtillery && !defendingUnit.hasArtillery) {
      updateEvents.add(PlaySound(
        type: attackingDamageType == DamageType.explosion || defendingDamageType == DamageType.explosion
            ? SoundType.attackExplosion
            : SoundType.attackShot,
        duration: deadUnits.isNotEmpty ? _animationTime.damageAnimationTime : null,
      ));

      updateEvents.add(
        ShowComplexDamage(
          cells: [
            Tuple2(attackingCell, attackingDamageType),
            Tuple2(defendingCell, defendingDamageType),
          ],
          time: _animationTime.damageAnimationTime,
        ),
      );
    }

    // Show damage - case 2 - the defending unit doesn't strike back
    if (attackingUnit.hasArtillery && !defendingUnit.hasArtillery) {
      updateEvents.add(PlaySound(
        type: defendingDamageType == DamageType.explosion ? SoundType.attackExplosion : SoundType.attackShot,
        duration: deadUnits.isNotEmpty ? _animationTime.damageAnimationTime : null,
      ));

      updateEvents.add(
        ShowDamage(
          cell: defendingCell,
          damageType: defendingDamageType,
          time: _animationTime.damageAnimationTime,
        ),
      );
    }

    // Show damage - case 3 - the attacking artillery strikes first, then the defending troop fires back.
    if (attackingUnit.hasArtillery && defendingUnit.hasArtillery) {
      updateEvents.add(PlaySound(
        type: defendingDamageType == DamageType.explosion ? SoundType.attackExplosion : SoundType.attackShot,
        duration: _animationTime.damageAnimationTime,
      ));

      updateEvents.add(
        ShowDamage(
          cell: defendingCell,
          damageType: defendingDamageType,
          time: _animationTime.damageAnimationTime,
        ),
      );

      updateEvents.add(PlaySound(
        type: attackingDamageType == DamageType.explosion ? SoundType.attackExplosion : SoundType.attackShot,
        duration: deadUnits.isNotEmpty ? _animationTime.damageAnimationTime : null,
        ignoreIfPlayed: false,
      ));

      updateEvents.add(
        ShowDamage(
          cell: attackingCell,
          damageType: attackingDamageType,
          time: _animationTime.damageAnimationTime,
        ),
      );
    }

    // Show damage - case 4 - the defending artillery strikes first, and the attacking troop strikes in the second place
    if (!attackingUnit.hasArtillery && defendingUnit.hasArtillery) {
      updateEvents.add(PlaySound(
        type: attackingDamageType == DamageType.explosion ? SoundType.attackExplosion : SoundType.attackShot,
        duration: _animationTime.damageAnimationTime,
      ));

      updateEvents.add(
        ShowDamage(
          cell: attackingCell,
          damageType: attackingDamageType,
          time: _animationTime.damageAnimationTime,
        ),
      );

      updateEvents.add(PlaySound(
        type: defendingDamageType == DamageType.explosion ? SoundType.attackExplosion : SoundType.attackShot,
        duration: deadUnits.isNotEmpty ? _animationTime.damageAnimationTime : null,
      ));

      updateEvents.add(
        ShowDamage(
          cell: defendingCell,
          damageType: defendingDamageType,
          time: _animationTime.damageAnimationTime,
        ),
      );
    }

    if (deadUnits.isNotEmpty) {
      updateEvents.add(PlaySound(
        type: deadUnits.getDeathSoundType(),
        strategy: SoundStrategy.putToQueue,
      ));
    }

    // Remove the attacking troop as a separate unit
    updateEvents.add(RemoveUntiedUnit(attackingUnit));

    if (pcCaptured) {
      updateEvents.add(PlaySound(
        type: SoundType.battleResultPcCaptured,
        strategy: SoundStrategy.putToQueue,
      ));
    } else if (pcDestroyed) {
      updateEvents.add(PlaySound(
        type: SoundType.battleResultPcDestroyed,
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
