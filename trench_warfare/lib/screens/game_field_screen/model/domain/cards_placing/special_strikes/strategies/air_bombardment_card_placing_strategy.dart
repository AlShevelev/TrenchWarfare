part of cards_placing;

class AirBombardmentCardPlacingStrategy extends SpecialStrikesCardsPlacingStrategy {
  AirBombardmentCardPlacingStrategy(
    super.updateGameObjectsEvent,
    super.cell,
    super.isAI,
    super.animationTime,
  );

  @override
  void updateGameField() {
    final hasAntiAir = _cell.terrainModifier?.type == TerrainModifierType.antiAirGun;

    Logger.info('AIR_BOMBARDMENT; hasAntiAir: $hasAntiAir', tag: 'SPECIAL_STRIKE');

    for (var unit in _cell.units) {
      final damage = RandomGen.randomDouble(unit.maxHealth * 0.5, unit.maxHealth) * (hasAntiAir ? 0.5 : 1);
      unit.setHealth(unit.health - damage);

      Logger.info('AIR_BOMBARDMENT; strike result. damage: $damage; unit: $unit', tag: 'SPECIAL_STRIKE');
    }

    _cell.units.where((u) => u.health <= 0).toList(growable: false).forEach((u) => _cell.removeUnit(u));
  }

  @override
  Iterable<UpdateGameEvent> _getUpdateEvents() => [
    PlaySound(type: SoundType.attackExplosion, delayAfterPlay: 0),
    ShowDamage(
      cell: _cell,
      damageType: DamageType.explosion,
      time: _animationTime.damageAnimationTime,
    ),
    UpdateCell(
      _cell,
      updateBorderCells: [],
    ),
    AnimationCompleted(),
  ];
}
