part of cards_placing;

class FlameTroopersCardPlacingStrategy extends SpecialStrikesCardsPlacingStrategy {
  FlameTroopersCardPlacingStrategy(
    super.updateGameObjectsEvent,
    super.cell,
    super.isAI,
    super.animationTime,
    super.unitUpdateResultBridge,
    super.myNation,
  );

  @override
  Unit? updateGameField() {
    final unit = _cell.activeUnit!;
    final isPcOnCell = _cell.productionCenter != null;

    final chanceToDevastate = switch (unit.type) {
          UnitType.infantry => 0.5,
          UnitType.tank => 0.075,
          _ => 0,
        } *
        (isPcOnCell ? 0.5 : 1.0);

    final random = RandomGen.randomDouble(0, 1);

    Logger.info(
      'FLAME_TROOPERS; unit: $unit; chanceToDevastate: $chanceToDevastate; random: $random',
      tag: 'SPECIAL_STRIKE',
    );

    Unit? killedUnit;
    if (random <= chanceToDevastate) {
      _unitUpdateResultBridge?.addBefore(nation: _cell.nation!, unit: Unit.copy(unit), cell: _cell);

      killedUnit = _cell.removeActiveUnit();

      Logger.info('FLAME_TROOPERS; unit is dead', tag: 'SPECIAL_STRIKE');
    }

    return killedUnit;
  }

  @override
  Iterable<UpdateGameEvent> _getUpdateEvents(Unit? killedUnit) {
    final events = <UpdateGameEvent>[];

    events.add(PlaySound(
      type: SoundType.attackFlame,
      duration: killedUnit == null ? null : _animationTime.damageAnimationTime,
    ));

    events.add(ShowDamage(
      cell: _cell,
      damageType: DamageType.flame,
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
