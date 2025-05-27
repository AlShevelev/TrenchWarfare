/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of movement;

mixin ShowDamageCalculator {
  List<UpdateGameEvent> calculateDamageEvents({
    required GameFieldCell attackingCell,
    required GameFieldCell defendingCell,
    required Unit attackingUnit,
    required Unit defendingUnit,
    required List<Unit> deadUnits,
    required AnimationTime animationTime,
  }) {
    final result = <UpdateGameEvent>[];

    final attackingUnitHasArtillery =
        attackingUnit.hasArtillery || attackingCell.terrainModifier?.type == TerrainModifierType.landFort;

    final defendingUnitHasArtillery =
        defendingUnit.hasArtillery || defendingCell.terrainModifier?.type == TerrainModifierType.landFort;

    final attackingDamageType = attackingUnit.isMechanical ? DamageType.explosion : DamageType.bloodSplash;
    final defendingDamageType = defendingUnit.isMechanical ? DamageType.explosion : DamageType.bloodSplash;

    // Show damage - case 1 - the defending unit doesn't strike back
    if (attackingUnitHasArtillery && !defendingUnitHasArtillery) {
      result.add(PlaySound(
        type: attackingUnitHasArtillery ? SoundType.attackExplosion : SoundType.attackShot,
        duration: deadUnits.isNotEmpty ? animationTime.damageAnimationTime : null,
      ));

      result.add(
        ShowDamage(
          cell: defendingCell,
          damageType: defendingDamageType,
          time: animationTime.damageAnimationTime,
        ),
      );
    }

    // Show damage - case 2 - the attacking artillery strikes first, then the defending troop fires back.
    if (attackingUnitHasArtillery && defendingUnitHasArtillery) {
      result.add(
        PlaySound(
          type: attackingUnitHasArtillery ? SoundType.attackExplosion : SoundType.attackShot,
          duration: animationTime.damageAnimationTime,
        ),
      );

      result.add(
        ShowDamage(
          cell: defendingCell,
          damageType: defendingDamageType,
          time: animationTime.damageAnimationTime,
        ),
      );

      result.add(
        PlaySound(
          type: defendingUnitHasArtillery ? SoundType.attackExplosion : SoundType.attackShot,
          duration: deadUnits.isNotEmpty ? animationTime.damageAnimationTime : null,
          ignoreIfPlayed: false,
        ),
      );

      result.add(
        ShowDamage(
          cell: attackingCell,
          damageType: attackingDamageType,
          time: animationTime.damageAnimationTime,
        ),
      );
    }

    // Show damage - case 3 - simultaneously
    if (!attackingUnitHasArtillery && !defendingUnitHasArtillery) {
      result.add(PlaySound(
        type: attackingUnitHasArtillery || defendingUnitHasArtillery
            ? SoundType.attackExplosion
            : SoundType.attackShot,
        duration: deadUnits.isNotEmpty ? animationTime.damageAnimationTime : null,
      ));

      result.add(
        ShowComplexDamage(
          cells: [
            Tuple2(attackingCell, attackingDamageType),
            Tuple2(defendingCell, defendingDamageType),
          ],
          time: animationTime.damageAnimationTime,
        ),
      );
    }

    // Show damage - case 4 - the defending artillery strikes first, and the attacking troop strikes in the second place
    if (!attackingUnitHasArtillery && defendingUnitHasArtillery) {
      result.add(PlaySound(
        type: defendingUnitHasArtillery ? SoundType.attackExplosion : SoundType.attackShot,
        duration: animationTime.damageAnimationTime,
      ));

      result.add(
        ShowDamage(
          cell: attackingCell,
          damageType: attackingDamageType,
          time: animationTime.damageAnimationTime,
        ),
      );

      result.add(PlaySound(
        type: attackingUnitHasArtillery ? SoundType.attackExplosion : SoundType.attackShot,
        duration: deadUnits.isNotEmpty ? animationTime.damageAnimationTime : null,
      ));

      result.add(
        ShowDamage(
          cell: defendingCell,
          damageType: defendingDamageType,
          time: animationTime.damageAnimationTime,
        ),
      );
    }

    if (deadUnits.isNotEmpty) {
      result.add(PlaySound(
        type: deadUnits.getDeathSoundType(),
        strategy: SoundStrategy.putToQueue,
      ));
    }

    return result;
  }
}
