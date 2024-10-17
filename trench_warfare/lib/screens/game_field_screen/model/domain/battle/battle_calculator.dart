part of battle;

class UnitsBattleCalculator {
  static const _fatigueForBattle = 0.2;

  static UnitsBattleResult calculateBattle({
    required Unit attacking,
    required GameFieldCell defendingCell,
  }) {
    final preparationCalculator = UnitInBattlePreparationCalculator(attacking, defendingCell);
    final attackingUnit = preparationCalculator.calculateAttackingUnit();
    final defendingUnit = preparationCalculator.calculateDefendingUnit();

    if (!attackingUnit.hasArtillery && !defendingUnit.hasArtillery) {
      // simultaneously
      final attackingDamage = _calculateDamage(attackingUnit, defendingUnit);
      final defendingDamage = _calculateDamage(defendingUnit, attackingUnit);

      attackingUnit.reduceHealth(defendingDamage);
      defendingUnit.reduceHealth(attackingDamage);

      attackingUnit.reduceFatigue(_fatigueForBattle);
      attackingUnit.increaseTookPartInBattles(1);

      defendingUnit.reduceFatigue(_fatigueForBattle);
      defendingUnit.increaseTookPartInBattles(1);
    }

    if (attackingUnit.hasArtillery && !defendingUnit.hasArtillery) {
      // the defending unit doesn't strike back
      final attackingDamage = _calculateDamage(attackingUnit, defendingUnit);
      attackingUnit.reduceFatigue(_fatigueForBattle);
      attackingUnit.increaseTookPartInBattles(1);

      defendingUnit.reduceHealth(attackingDamage);
    }

    if (attackingUnit.hasArtillery && defendingUnit.hasArtillery) {
      // the attacking artillery strikes first, then the defending troop fires back.
      final attackingDamage = _calculateDamage(attackingUnit, defendingUnit);
      attackingUnit.reduceFatigue(_fatigueForBattle);
      attackingUnit.increaseTookPartInBattles(1);

      defendingUnit.reduceHealth(attackingDamage);

      if (defendingUnit.health > 0) {
        final defendingDamage = _calculateDamage(defendingUnit, attackingUnit);
        defendingUnit.reduceFatigue(_fatigueForBattle);
        defendingUnit.increaseTookPartInBattles(1);

        attackingUnit.reduceHealth(defendingDamage);
      }
    }

    if (!attackingUnit.hasArtillery && defendingUnit.hasArtillery) {
      // the defending artillery strikes first, and the attacking troop strikes in the second place
      final defendingDamage = _calculateDamage(defendingUnit, attackingUnit);
      defendingUnit.reduceFatigue(_fatigueForBattle);
      defendingUnit.increaseTookPartInBattles(1);

      attackingUnit.reduceHealth(defendingDamage);

      if (attackingUnit.health > 0) {
        final attackingDamage = _calculateDamage(attackingUnit, defendingUnit);
        attackingUnit.reduceFatigue(_fatigueForBattle);
        attackingUnit.increaseTookPartInBattles(1);

        defendingUnit.reduceHealth(attackingDamage);
      }
    }

    return _calculateUltimateResult(attackingUnit, defendingUnit);
  }

  static double _calculateDamage(UnitInBattle attacking, UnitInBattle defending) {
    final startDamage = RandomGen.randomDouble(attacking.damage.min, attacking.damage.max);

    var damageBase = startDamage;

    if (attacking.attack > defending.defence) {
      damageBase += startDamage * 0.1 * (attacking.attack / defending.defence);
    } else if (attacking.attack < defending.defence) {
      damageBase -= startDamage * 0.05 * (defending.defence / attacking.attack);
    }

    damageBase = math.max(attacking.damage.min, damageBase);

    var damageExp = startDamage +
        startDamage *
            0.125 *
            (UnitExperienceRank.asNumber(attacking.experienceRank) -
                UnitExperienceRank.asNumber(defending.experienceRank));

    damageExp = math.max(attacking.damage.min, damageExp);

    final damageFatigue = startDamage + startDamage * attacking._fatigue;

    final damageHealth = startDamage + startDamage * (attacking._health / defending.maxHealth);

    var totalDamage = (damageBase + damageExp + damageFatigue + damageHealth) / 4.0;

    if (totalDamage < 0.0) {
      totalDamage = 0.0;
    }

    return totalDamage;
  }

  static UnitsBattleResult _calculateUltimateResult(UnitInBattle attacking, UnitInBattle defending) {
    late UnitBattleResult attackingResult;
    late UnitBattleResult defendingResult;

    attackingResult = (attacking.health <= 0) ? Died() : Alive(attacking);

    if (defending.health <= 0) {
      defendingResult = Died();
    } else {
      if (defending.healthBeforeBattle - defending.health > defending.maxHealth / 2) {
        defendingResult = InPanic(defending);
      } else {
        defendingResult = Alive(defending);
      }
    }

    return UnitsBattleResult(attacking: attackingResult, defending: defendingResult);
  }
}
