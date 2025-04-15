part of cards_placing;

class AirBombardmentCardPlacingStrategy extends SpecialStrikesCardsPlacingStrategy {
  AirBombardmentCardPlacingStrategy(
    super.updateGameObjectsEvent,
    super.cell,
    super.isAI,
    super.animationTime,
    super.unitUpdateResultBridge,
    super.myNation,
  );

  /// [return] killed units (or hit by propaganda)
  @override
  Unit? updateGameField() {
    final hasAntiAir = _cell.terrainModifier?.type == TerrainModifierType.antiAirGun ||
        _cell.terrainModifier?.type == TerrainModifierType.landFort ||
        _cell.productionCenter != null;

    Logger.info('AIR_BOMBARDMENT; hasAntiAir: $hasAntiAir', tag: 'SPECIAL_STRIKE');

    final killedUnits = <Unit>[];
    for (var unit in _cell.units) {
      _unitUpdateResultBridge?.addBefore(nation: _cell.nation!, unit: Unit.copy(unit), cell: _cell);

      final damage = RandomGen.randomDouble(unit.maxHealth * 0.5, unit.maxHealth) * (hasAntiAir ? 0.5 : 1);
      unit.setHealth(unit.health - damage);

      Logger.info('AIR_BOMBARDMENT; strike result. damage: $damage; unit: $unit', tag: 'SPECIAL_STRIKE');

      if (unit.health <= 0) {
        killedUnits.add(unit);
      } else {
        _unitUpdateResultBridge?.addAfter(nation: _cell.nation!, unit: Unit.copy(unit), cell: _cell);
      }
    }

    // ignore: avoid_function_literals_in_foreach_calls
    killedUnits.forEach((u) => _cell.removeUnit(u));

    return killedUnits.firstOrNull;
  }

  @override
  Iterable<UpdateGameEvent> _getUpdateEvents(Unit? killedUnit) {
    final events = <UpdateGameEvent>[];

    events.add(
      PlaySound(
        type: SoundType.attackExplosion,
        duration: killedUnit == null ? null : _animationTime.damageAnimationTime,
      ),
    );

    events.add(
      ShowDamage(
        cell: _cell,
        damageType: DamageType.explosion,
        time: _animationTime.damageAnimationTime,
      ),
    );

    if (killedUnit != null) {
      events.add(
        PlaySound(
          type: killedUnit.getDeathSoundType(),
          strategy: SoundStrategy.putToQueue,
        ),
      );
    }

    events.add(
      UpdateCell(
        _cell,
        updateBorderCells: [],
      ),
    );
    events.add(
      AnimationCompleted(),
    );

    return events;
  }
}
