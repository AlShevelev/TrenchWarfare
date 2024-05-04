part of cards_placing;

class FlechettesCardPlacingStrategy extends SpecialStrikesCardsPlacingStrategy {
  FlechettesCardPlacingStrategy(super.updateGameObjectsEvent, super.cell);

  @override
  void updateGameField() {
    final hasAntiAir = _cell.terrainModifier?.type == TerrainModifierType.antiAirGun;

    for (var unit in _cell.units) {
      if (unit.isMechanical) {
        continue;
      }

      final damage = RandomGen.randomDouble(unit.maxHealth  * 0.25, unit.maxHealth  * 0.5) * (hasAntiAir ? 0.5 : 1);
      unit.setHealth(unit.health - damage);
    }

    _cell.units.where((u) => u.health <= 0).toList(growable: false).forEach((u) => _cell.removeUnit(u));
  }

  @override
  void showUpdate() {
    _updateGameObjectsEvent.update([
      ShowDamage(
        cell: _cell,
        damageType: DamageType.bloodSplash,
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