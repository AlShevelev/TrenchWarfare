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
  void updateGameField() {
    updateCell(_cell, chanceToKill: 0.2, chanceToReduceHealth: 0.4);

    final allCellsAround = _gameField
        .findCellsAround(_cell)
        .where((c) => c.isLand && c.units.isNotEmpty)
        .toList(growable: false);

    for (var cell in allCellsAround) {
      if (RandomGen.randomDouble(0, 1) <= 0.25) {
        updateCell(cell, chanceToKill: 0.1, chanceToReduceHealth: 0.2);
      }
    }
  }

  void updateCell(GameFieldCell cell, {required double chanceToKill, required double chanceToReduceHealth}) {
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

    cell.units.where((u) => u.health <= 0).toList(growable: false).forEach((u) => cell.removeUnit(u));

    _updatedCells.add(cell);
  }

  @override
  Iterable<UpdateGameEvent> _getUpdateEvents() {
    final List<UpdateGameEvent> updateEvents = [];

    updateEvents.add(
      PlaySound(type: SoundType.attackGas, delayAfterPlay: 0)
    );

    updateEvents.add(
      ShowComplexDamage(
        cells: _updatedCells.map((c) => Tuple2(c, DamageType.gasAttack)),
        time: _animationTime.damageAnimationTime,
      ),
    );

    updateEvents.addAll(_updatedCells.map((c) => UpdateCell(c, updateBorderCells: [])));
    updateEvents.add(AnimationCompleted());

    return updateEvents;
  }
}
