part of cards_placing;

class AirBombardmentCardPlacingStrategy extends SpecialStrikesCardsPlacingStrategy {
  late final GameFieldCell _cell;

  AirBombardmentCardPlacingStrategy(super.updateGameObjectsEvent, GameFieldCell cell) {
    _cell = cell;
  }

  @override
  void updateGameField() {
    final hasAntiAir = _cell.terrainModifier?.type == TerrainModifierType.antiAirGun;

    for (var unit in _cell.units) {
      final damage = RandomGen.random(unit.maxHealth / 2, unit.maxHealth) * (hasAntiAir ? 0.5 : 1);
      unit.setHealth(unit.health - damage);
    }

    _cell.units.where((u) => u.health <= 0).toList(growable: false).forEach((u) => _cell.removeUnit(u));
  }

  @override
  void showUpdate() {
    _updateGameObjectsEvent.update([
      ShowDamage(
        cell: _cell,
        damageType: DamageType.explosion,
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
