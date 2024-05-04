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
  ) {
    _gameField = gameField;
    _myNation = myNation;
  }

  @override
  void updateGameField() {
    final activeUnit = _cell.activeUnit!;

    final chanceToSuccess = _calculateChanceToSuccess(activeUnit);

    if (RandomGen.randomDouble(0, 1) <= chanceToSuccess) {
      final possibleEffects = _calculatePossibleEffects();

      _effect = possibleEffects[RandomGen.randomInt(possibleEffects.length)];

      switch (_effect) {
        case _DecreaseDefense():
          {
            activeUnit.setDefence((activeUnit.defence ~/ 2).toDouble());
          }
        case _Deserting():
          {
            _cell.removeActiveUnit();
          }
        case _RunAway(newCell: var newCell):
          {
            _cell.removeActiveUnit();
            newCell.addUnitAsActive(activeUnit);
          }
        case _Convert():
          {
            _cell.setNation(_myNation);
          }
      }
    }
  }

  @override
  void showUpdate() {
    final List<UpdateGameEvent> updateEvents = [];

    updateEvents.add(ShowDamage(
      cell: _cell,
      damageType: DamageType.propaganda,
      time: MovementConstants.damageAnimationTime,
    ));

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
            MoveUntiedUnit(
              startCell: _cell,
              endCell: newCell,
              unit: unit,
              time: MovementConstants.unitMovementTime,
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
    _updateGameObjectsEvent.update(updateEvents);
  }

  double _calculateChanceToSuccess(Unit unit) {
    final experienceFactor = switch (unit.experienceRank) {
      UnitExperienceRank.rookies => 1,
      UnitExperienceRank.fighters => 2,
      UnitExperienceRank.proficients => 3,
      UnitExperienceRank.veterans => 4,
      UnitExperienceRank.elite => 5,
    };

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
}
