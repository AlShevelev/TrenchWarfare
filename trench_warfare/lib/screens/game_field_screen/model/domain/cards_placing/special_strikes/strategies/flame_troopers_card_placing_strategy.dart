part of cards_placing;

class FlameTroopersCardPlacingStrategy extends SpecialStrikesCardsPlacingStrategy {
  FlameTroopersCardPlacingStrategy(
    super.updateGameObjectsEvent,
    super.cell,
    super.isAI,
    super.animationTime,
  );

  @override
  void updateGameField() {
    final unit = _cell.activeUnit!;

    final chanceToDevastate = switch (unit.type) {
      UnitType.infantry => 0.75,
      UnitType.tank => 0.075,
      _ => 0,
    };

    final random = RandomGen.randomDouble(0, 1);

    Logger.info(
      'FLAME_TROOPERS; unit: $unit; chanceToDevastate: $chanceToDevastate; random: $random',
      tag: 'SPECIAL_STRIKE',
    );

    if (random <= chanceToDevastate) {
      _cell.removeActiveUnit();

      Logger.info('FLAME_TROOPERS; unit is dead', tag: 'SPECIAL_STRIKE');
    }
  }

  @override
  Iterable<UpdateGameEvent> _getUpdateEvents() => [
        ShowDamage(
          cell: _cell,
          damageType: DamageType.flame,
          time: _animationTime.damageAnimationTime,
        ),
        UpdateCell(
          _cell,
          updateBorderCells: [],
        ),
        AnimationCompleted(),
      ];
}
