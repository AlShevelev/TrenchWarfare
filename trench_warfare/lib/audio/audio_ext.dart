/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of audio;

extension UnitsAudioExt on Iterable<Unit> {
  SoundType getDeathSoundType() {
    if (any((u) => !u.isMechanical)) {
      return SoundType.battleResultManDeath;
    } else if (any((u) => u.isShip)) {
      return SoundType.battleResultShipDestroyed;
    } else {
      return SoundType.battleResultMechanicalDestroyed;
    }
  }
}

extension UnitAudioExt on Unit {
  SoundType getDeathSoundType() =>
    switch (type) {
      UnitType.armoredCar => SoundType.battleResultMechanicalDestroyed,
      UnitType.artillery => SoundType.battleResultMechanicalDestroyed,
      UnitType.infantry => SoundType.battleResultManDeath,
      UnitType.cavalry => SoundType.battleResultManDeath,
      UnitType.machineGunnersCart => SoundType.battleResultMechanicalDestroyed,
      UnitType.machineGuns => SoundType.battleResultManDeath,
      UnitType.tank => SoundType.battleResultMechanicalDestroyed,
      UnitType.destroyer => SoundType.battleResultShipDestroyed,
      UnitType.cruiser => SoundType.battleResultShipDestroyed,
      UnitType.battleship => SoundType.battleResultShipDestroyed,
      UnitType.carrier => SoundType.battleResultShipDestroyed,
    };

  SoundType getProductionSoundType() =>
    switch (type) {
      UnitType.armoredCar => SoundType.productionMechanical,
      UnitType.artillery => SoundType.productionMechanical,
      UnitType.infantry => SoundType.productionInfantry,
      UnitType.cavalry => SoundType.productionCavalry,
      UnitType.machineGunnersCart => SoundType.productionMechanical,
      UnitType.machineGuns => SoundType.productionInfantry,
      UnitType.tank => SoundType.productionMechanical,
      UnitType.destroyer => SoundType.productionShip,
      UnitType.cruiser => SoundType.productionShip,
      UnitType.battleship => SoundType.productionShip,
      UnitType.carrier => SoundType.productionShip,
    };
}
