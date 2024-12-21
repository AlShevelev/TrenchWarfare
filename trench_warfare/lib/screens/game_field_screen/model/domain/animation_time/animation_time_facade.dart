part of animation_time;

class AnimationTimeFacade {
  /// A time in milliseconds to move from one cell to another
  static const int unitMovementTimeMin = 200;
  static const int unitMovementTimeMax = 500;

  /// A pause in milliseconds just after movement
  static const int unitMovementPause = 0;

  /// A time in milliseconds to show damage animation
  static const int damageAnimationTime = 500;

  /// A pause in milliseconds just after building something (unit, PC, etc.)
  static const int pauseAfterBuildingAi = 350;
  static const int pauseAfterBuildingHuman = 10;

  late final _AnimationTimeCalculator _humanCalculator;
  late final _AnimationTimeCalculator _aiCalculator;

  AnimationTimeFacade({
    required double humanUnitsSpeed,
    required final double aiUnitsSpeed,
  }) {
    _humanCalculator = _AnimationTimeCalculator(
      unitMovementTimeBase: Range<int>(unitMovementTimeMin, unitMovementTimeMax),
      settingsUnitTimeValue: humanUnitsSpeed,
      unitMovementPause: unitMovementPause,
      damageAnimationTime: damageAnimationTime,
      pauseAfterBuilding: pauseAfterBuildingHuman,
    );

    _aiCalculator = _AnimationTimeCalculator(
      unitMovementTimeBase: Range<int>(unitMovementTimeMin, unitMovementTimeMax),
      settingsUnitTimeValue: aiUnitsSpeed,
      unitMovementPause: unitMovementPause,
      damageAnimationTime: damageAnimationTime,
      pauseAfterBuilding: pauseAfterBuildingAi,
    );
  }

  AnimationTime getAnimationTime(bool isHuman) => isHuman ? _humanCalculator : _aiCalculator;

  void updateTime(SettingsResult result) {
    _humanCalculator.updateSettingsUnitTimeValue(result.humanUnitsSpeed);
    _aiCalculator.updateSettingsUnitTimeValue(result.aiUnitsSpeed);
  }
}
