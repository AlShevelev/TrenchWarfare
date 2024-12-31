part of cards_placing;

class FlechettesCardPlacingStrategy extends SpecialStrikesCardsPlacingStrategy {
  FlechettesCardPlacingStrategy(
    super.updateGameObjectsEvent,
    super.cell,
    super.isAI,
    super.animationTime,
  );

  @override
  void updateGameField() {
    final hasAntiAir = _cell.terrainModifier?.type == TerrainModifierType.antiAirGun;

    Logger.info('FLECHETTES; hasAntiAir: $hasAntiAir', tag: 'SPECIAL_STRIKE');

    for (var unit in _cell.units) {
      if (unit.isMechanical) {
        Logger.info('FLECHETTES; unit isMechanical - skip', tag: 'SPECIAL_STRIKE');
        continue;
      }

      final damage =
          RandomGen.randomDouble(unit.maxHealth * 0.25, unit.maxHealth * 0.5) * (hasAntiAir ? 0.5 : 1);
      unit.setHealth(unit.health - damage);

      Logger.info('FLECHETTES; strike result. damage: $damage; unit: $unit', tag: 'SPECIAL_STRIKE');
    }

    _cell.units.where((u) => u.health <= 0).toList(growable: false).forEach((u) => _cell.removeUnit(u));
  }

  @override
  Iterable<UpdateGameEvent> _getUpdateEvents() => [
        PlaySound(type: SoundType.attackFlechettes, delayAfterPlay: 0),
        ShowDamage(
          cell: _cell,
          damageType: DamageType.bloodSplash,
          time: _animationTime.damageAnimationTime,
        ),
        UpdateCell(
          _cell,
          updateBorderCells: [],
        ),
        AnimationCompleted(),
      ];
}
