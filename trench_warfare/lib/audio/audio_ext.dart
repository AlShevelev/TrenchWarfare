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
  SoundType getDeathSoundType() {
    if (isShip) {
      return SoundType.battleResultShipDestroyed;
    } else if (isMechanical) {
      return SoundType.battleResultMechanicalDestroyed;
    } else {
      return SoundType.battleResultManDeath;
    }
  }
}
