/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of animation_time;

abstract interface class AnimationTime {
  /// A time in milliseconds to move from one cell to another
  int get unitMovementTime;

  /// A pause in milliseconds just after movement
  int get unitMovementPause;

  /// A time in milliseconds to show damage animation
  int get damageAnimationTime;

  /// A pause in milliseconds just after building something (unit, PC, etc.)
  int get pauseAfterBuilding;
}

class _AnimationTimeCalculator implements AnimationTime {
  final Range<int> _unitMovementTimeBase;

  int _unitMovementTime = 0;
  @override
  int get unitMovementTime => _unitMovementTime;

  @override
  final int unitMovementPause;

  @override
  final int damageAnimationTime;

  @override
  final int pauseAfterBuilding;

  _AnimationTimeCalculator({
    required Range<int> unitMovementTimeBase,
    required double settingsUnitTimeValue,
    required this.unitMovementPause,
    required this.damageAnimationTime,
    required this.pauseAfterBuilding,
  }) : _unitMovementTimeBase = unitMovementTimeBase {
    updateSettingsUnitTimeValue(settingsUnitTimeValue);
  }

  void updateSettingsUnitTimeValue(double settingsUnitTimeValue) =>
      _unitMovementTime = _unitMovementTimeBase.max -
          ((_unitMovementTimeBase.max - _unitMovementTimeBase.min) * (settingsUnitTimeValue / 100.0)).round();
}
