part of cards_placing;

class FlameTroopersCardPlacingStrategy extends SpecialStrikesCardsPlacingStrategy {
  FlameTroopersCardPlacingStrategy(super.updateGameObjectsEvent, super.cell);

  @override
  void updateGameField() {
    final unit = _cell.activeUnit!;

    final chanceToDevastate = switch(unit.type) {
      UnitType.infantry => 0.5,
      UnitType.tank => 0.25,
      _ => 0
    };

    final random = RandomGen.random(0, 1);
    if (random <= chanceToDevastate) {
      _cell.removeActiveUnit();
    }
  }

  @override
  void showUpdate() {
    _updateGameObjectsEvent.update([
      ShowDamage(
        cell: _cell,
        damageType: DamageType.flame,
        time: MovementConstants.damageAnimationTime,
      ),
      UpdateCell(
        _cell,
        updateBorderCells: [],
      ),
      AnimationCompleted(),
    ]);
  }
}