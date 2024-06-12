part of cards_placing;

class GasAttackCardPlacingStrategy extends SpecialStrikesCardsPlacingStrategy {
  late final GameFieldRead _gameField;

  final List<GameFieldCell> _updatedCells = [];

  GasAttackCardPlacingStrategy(
    super.updateGameObjectsEvent,
    super.cell,
    GameFieldRead gameField,
    super.isAI,
  ) {
    _gameField = gameField;
  }

  @override
  void updateGameField() {
    updateCell(_cell, chanceToKill: 0.45, chanceToReduceHealth: 0.9);

    final allCellsAround = _gameField
        .findCellsAround(_cell)
        .where((c) => c.isLand && c.units.isNotEmpty)
        .toList(growable: false);

    for (var cell in allCellsAround) {
      if (RandomGen.randomDouble(0, 1) <= 0.25) {
        updateCell(cell, chanceToKill: 0.225, chanceToReduceHealth: 0.45);
      }
    }
  }

  void updateCell(GameFieldCell cell, {required double chanceToKill, required double chanceToReduceHealth}) {
    for (var unit in cell.units) {
      final random = RandomGen.randomDouble(0, 1);

      if (random <= chanceToKill) {
        unit.setHealth(0);
      } else if (random <= chanceToReduceHealth) {
        unit.setHealth(unit.health / 2);
      }
    }

    cell.units.where((u) => u.health <= 0).toList(growable: false).forEach((u) => cell.removeUnit(u));

    _updatedCells.add(cell);
  }

  @override
  Iterable<UpdateGameEvent> _getUpdateEvents() {
    final List<UpdateGameEvent> updateEvents = [];

    updateEvents.add(ShowComplexDamage(
      cells: _updatedCells.map((c) => Tuple2(c, DamageType.gasAttack)),
      time: MovementConstants.damageAnimationTime,
    ));

    updateEvents.addAll(_updatedCells.map((c) => UpdateCell(c, updateBorderCells: [])));
    updateEvents.add(AnimationCompleted());

    return updateEvents;
  }
}
