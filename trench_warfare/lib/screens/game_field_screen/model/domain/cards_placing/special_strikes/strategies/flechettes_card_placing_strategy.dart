part of cards_placing;

class FlechettesCardPlacingStrategy extends SpecialStrikesCardsPlacingStrategy {
  FlechettesCardPlacingStrategy(
    super.updateGameObjectsEvent,
    super.cell,
    super.isAI,
    super.animationTime,
  );

  @override
  Unit? updateGameField() {
    final hasAntiAir =
        _cell.terrainModifier?.type == TerrainModifierType.antiAirGun || _cell.productionCenter != null;

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

    final killedUnits = _cell.units.where((u) => u.health <= 0).toList(growable: false);

    // ignore: avoid_function_literals_in_foreach_calls
    killedUnits.forEach((u) => _cell.removeUnit(u));

    return killedUnits.firstOrNull;
  }

  @override
  Iterable<UpdateGameEvent> _getUpdateEvents(Unit? killedUnit) {
    final events = <UpdateGameEvent>[];

    events.add(PlaySound(
      type: SoundType.attackFlechettes,
      duration: killedUnit == null ? null : _animationTime.damageAnimationTime,
    ));

    events.add(ShowDamage(
      cell: _cell,
      damageType: DamageType.bloodSplash,
      time: _animationTime.damageAnimationTime,
    ));

    if (killedUnit != null) {
      events.add(PlaySound(
        type: killedUnit.getDeathSoundType(),
        strategy: SoundStrategy.putToQueue,
      ));
    }

    events.add(UpdateCell(
      _cell,
      updateBorderCells: [],
    ));

    events.add(AnimationCompleted());

    return events;
  }
}
