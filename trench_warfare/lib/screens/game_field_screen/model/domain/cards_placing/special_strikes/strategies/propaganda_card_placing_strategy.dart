part of cards_placing;

abstract class _PropagandaEffect {}

class _DecreaseDefense implements _PropagandaEffect {}

class _Deserting implements _PropagandaEffect {}

class _RunAway implements _PropagandaEffect {
  final GameFieldCell newCell;
  final Unit unit;

  _RunAway(this.newCell, this.unit);
}

class _Convert implements _PropagandaEffect {}

class PropagandaCardPlacingStrategy extends SpecialStrikesCardsPlacingStrategy {
  late final GameFieldRead _gameField;

  _PropagandaEffect? _effect;

  PropagandaCardPlacingStrategy(
    super.updateGameObjectsEvent,
    super.cell,
    GameFieldRead gameField,
    super.isAI,
    super.animationTime,
    super.unitUpdateResultBridge,
    super.myNation,
  ) : _gameField = gameField;

  @override
  Unit? updateGameField() {
    final activeUnit = _cell.activeUnit!;

    Unit? affectedUnit = activeUnit;

    final chanceToSuccess = _calculateChanceToSuccess(activeUnit, _cell);

    final random = RandomGen.randomDouble(0, 1);

    Logger.info(
        'PROPAGANDA; cell: $_cell; unit: $activeUnit; chanceToSuccess: $chanceToSuccess; '
        'random: $random',
        tag: 'SPECIAL_STRIKE');

    if (random <= chanceToSuccess) {
      final possibleEffects = _calculatePossibleEffects();

      _effect = possibleEffects[RandomGen.randomInt(possibleEffects.length)];

      switch (_effect) {
        case _DecreaseDefense():
          {
            _unitUpdateResultBridge?.addBefore(
              nation: _cell.nation!,
              unit: Unit.copy(activeUnit),
              cell: _cell,
            );

            activeUnit.setDefence((activeUnit.defence ~/ 2).toDouble());

            _unitUpdateResultBridge?.addAfter(
              nation: _cell.nation!,
              unit: Unit.copy(activeUnit),
              cell: _cell,
            );
            Logger.info('PROPAGANDA; effect is DecreaseDefense', tag: 'SPECIAL_STRIKE');
          }
        case _Deserting():
          {
            _unitUpdateResultBridge?.addBefore(
              nation: _cell.nation!,
              unit: Unit.copy(activeUnit),
              cell: _cell,
            );

            _cell.removeActiveUnit();
            Logger.info('PROPAGANDA; effect is Deserting', tag: 'SPECIAL_STRIKE');
          }
        case _RunAway(newCell: var newCell):
          {
            _unitUpdateResultBridge?.addBefore(
              nation: _cell.nation!,
              unit: Unit.copy(activeUnit),
              cell: _cell,
            );

            _cell.removeActiveUnit();
            newCell.addUnitAsActive(activeUnit);

            _unitUpdateResultBridge?.addAfter(
              nation: newCell.nation!,
              unit: Unit.copy(activeUnit),
              cell: newCell,
            );

            Logger.info('PROPAGANDA; effect is RunAway to: $newCell', tag: 'SPECIAL_STRIKE');
          }
        case _Convert():
          {
            for (final unit in _cell.units) {
              _unitUpdateResultBridge?.addBefore(
                nation: _cell.nation!,
                unit: Unit.copy(unit),
                cell: _cell,
              );
            }

            _cell.setNation(_myNation);

            for (final unit in _cell.units) {
              _unitUpdateResultBridge?.addAfter(
                nation: _cell.nation!,
                unit: Unit.copy(unit),
                cell: _cell,
              );
            }
            Logger.info('PROPAGANDA; effect is Convert', tag: 'SPECIAL_STRIKE');
          }
      }
    } else {
      _effect = null;
      affectedUnit = null;
      Logger.info('PROPAGANDA; no effect', tag: 'SPECIAL_STRIKE');
    }

    return affectedUnit;
  }

  double _calculateChanceToSuccess(Unit unit, GameFieldCellRead cell) {
    final experienceFactor = UnitExperienceRank.asNumber(unit.experienceRank);
    final isPcOnCell = cell.productionCenter != null;

    final calculatedChance = ((1 - experienceFactor * 0.2) + (1 - unit.health / unit.maxHealth)) / 2;

    return calculatedChance * (isPcOnCell ? 0.5 : 1.0);
  }

  List<_PropagandaEffect> _calculatePossibleEffects() {
    final possibleEffects = [_DecreaseDefense(), _Deserting()];

    if (_cell.units.length == 1) {
      possibleEffects.add(_Convert());
    }

    final cellToRunAway = _gameField
        .findCellsAround(_cell)
        .where((c) => c.nation == _cell.nation && c.units.isEmpty && c.isLand == _cell.isLand)
        .firstOrNull;

    if (cellToRunAway != null) {
      possibleEffects.add(_RunAway(cellToRunAway, _cell.activeUnit!));
    }

    return possibleEffects;
  }

  /// [killedUnit] is a unit, affected by propaganda
  @override
  Iterable<UpdateGameEvent> _getUpdateEvents(Unit? killedUnit) {
    final List<UpdateGameEvent> updateEvents = [];

    updateEvents.add(
      PlaySound(
        type: _effect == null ? SoundType.attackPropagandaFail : SoundType.attackPropagandaSuccess,
      ),
    );

    updateEvents.add(
      ShowDamage(
        cell: _cell,
        damageType: DamageType.propaganda,
        time: _animationTime.damageAnimationTime,
      ),
    );

    switch (_effect) {
      case _DecreaseDefense():
        {
          // do nothing
        }
      case _Deserting():
        {
          updateEvents.add(UpdateCell(_cell, updateBorderCells: []));
        }
      case _RunAway(newCell: var newCell, unit: var unit):
        {
          updateEvents.addAll([
            CreateUntiedUnit(_cell, unit),
            UpdateCell(_cell, updateBorderCells: []),
            MoveCameraToCell(_cell),
            MoveUntiedUnit(
              startCell: _cell,
              endCell: newCell,
              unit: unit,
              time: _animationTime.unitMovementTime,
            ),
            UpdateCell(newCell, updateBorderCells: []),
            RemoveUntiedUnit(unit),
          ]);
        }
      case _Convert():
        {
          updateEvents.add(UpdateCell(_cell, updateBorderCells: _gameField.findCellsAround(_cell)));
        }
    }

    updateEvents.add(AnimationCompleted());

    return updateEvents;
  }
}
