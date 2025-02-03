part of cards_placing;

class GasAttackCardPlacingStrategy extends SpecialStrikesCardsPlacingStrategy {
  late final GameFieldRead _gameField;

  final List<GameFieldCell> _updatedCells = [];

  GasAttackCardPlacingStrategy(
    super.updateGameObjectsEvent,
    super.cell,
    GameFieldRead gameField,
    super.isAI,
    super.animationTime,
  ) {
    _gameField = gameField;
  }

  @override
  Unit? updateGameField() {
    Unit? killedUnitCandidate;

    killedUnitCandidate = updateCell(_cell, chanceToKill: 0.4, chanceToReduceHealth: 0.8);

    final allCellsAround = _gameField
        .findCellsAround(_cell)
        .where((c) => c.isLand && c.units.isNotEmpty)
        .toList(growable: false);

    for (var cell in allCellsAround) {
      if (RandomGen.randomDouble(0, 1) <= 0.5) {
        final killedUnit = updateCell(cell, chanceToKill: 0.3, chanceToReduceHealth: 0.6);
        killedUnitCandidate ??= killedUnit;
      }
    }

    return killedUnitCandidate;
  }

  Unit? updateCell(GameFieldCell cell, {required double chanceToKill, required double chanceToReduceHealth}) {
    final random = RandomGen.randomDouble(0, 1);

    Logger.info(
        'GAS_ATTACK; cell: $cell; chanceToKill: $chanceToKill; chanceToReduceHealth: $chanceToReduceHealth; '
        'random: $random',
        tag: 'SPECIAL_STRIKE');

    for (var unit in cell.units) {
      if (random <= chanceToKill) {
        unit.setHealth(0);

        Logger.info('GAS_ATTACK; killed unit: $unit killed;', tag: 'SPECIAL_STRIKE');
      } else if (random <= chanceToReduceHealth) {
        unit.setHealth(unit.health / 2);

        Logger.info('GAS_ATTACK; health halved for unit: $unit killed', tag: 'SPECIAL_STRIKE');
      }
    }

    final killedUnits = cell.units.where((u) => u.health <= 0).toList(growable: false);

    // ignore: avoid_function_literals_in_foreach_calls
    killedUnits.forEach((u) => cell.removeUnit(u));

    _updatedCells.add(cell);

    return killedUnits.firstOrNull;
  }

  @override
  Iterable<UpdateGameEvent> _getUpdateEvents(Unit? killedUnit) {
    final updateEvents = <UpdateGameEvent>[];

    updateEvents.add(PlaySound(
      type: SoundType.attackGas,
      duration: killedUnit == null ? null : (_animationTime.damageAnimationTime * 1.5).toInt(),
    ));

    updateEvents.add(
      ShowComplexDamage(
        cells: _updatedCells.map((c) => Tuple2(c, DamageType.gasAttack)),
        time: _animationTime.damageAnimationTime,
      ),
    );

    if (killedUnit != null) {
      updateEvents.add(PlaySound(
        type: killedUnit.getDeathSoundType(),
        strategy: SoundStrategy.putToQueue,
      ));
    }

    updateEvents.addAll(_updatedCells.map((c) => UpdateCell(c, updateBorderCells: [])));
    updateEvents.add(AnimationCompleted());

    return updateEvents;
  }
}
