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

  late final Nation _myNation;

  _PropagandaEffect? _effect;

  PropagandaCardPlacingStrategy(
    super.updateGameObjectsEvent,
    super.cell,
    GameFieldRead gameField,
    Nation myNation,
    super.isAI,
    super.animationTime,
  ) {
    _gameField = gameField;
    _myNation = myNation;
  }

  @override
  void updateGameField() {
    final activeUnit = _cell.activeUnit!;

    final chanceToSuccess = _calculateChanceToSuccess(activeUnit);

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
            activeUnit.setDefence((activeUnit.defence ~/ 2).toDouble());
            Logger.info('PROPAGANDA; effect is DecreaseDefense', tag: 'SPECIAL_STRIKE');
          }
        case _Deserting():
          {
            _cell.removeActiveUnit();
            Logger.info('PROPAGANDA; effect is Deserting', tag: 'SPECIAL_STRIKE');
          }
        case _RunAway(newCell: var newCell):
          {
            _cell.removeActiveUnit();
            newCell.addUnitAsActive(activeUnit);
            Logger.info('PROPAGANDA; effect is RunAway to: $newCell', tag: 'SPECIAL_STRIKE');
          }
        case _Convert():
          {
            _cell.setNation(_myNation);
            Logger.info('PROPAGANDA; effect is Convert', tag: 'SPECIAL_STRIKE');
          }
      }
    } else {
      _effect = null;
      Logger.info('PROPAGANDA; no effect', tag: 'SPECIAL_STRIKE');
    }
  }

  double _calculateChanceToSuccess(Unit unit) {
    final experienceFactor = UnitExperienceRank.asNumber(unit.experienceRank);

    return ((1 - experienceFactor * 0.2) + (1 - unit.health / unit.maxHealth)) / 2;
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

  @override
  Iterable<UpdateGameEvent> _getUpdateEvents() {
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
