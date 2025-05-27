/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of settings;

sealed class _SettingsScreenState {
  bool get isCloseActionEnabled;
}

class _Loading extends _SettingsScreenState {
  @override
  bool get isCloseActionEnabled => false;
}

class _DataIsLoaded extends _SettingsScreenState {
  @override
  bool get isCloseActionEnabled => true;

  /// [SettingsConstants.minValue - SettingsConstants.maxValue]
  final double music;

  /// [SettingsConstants.minValue - SettingsConstants.maxValue]
  final double sounds;

  /// [SettingsConstants.minValue - SettingsConstants.maxValue]
  final double myUnitsSpeed;

  /// [SettingsConstants.minValue - SettingsConstants.maxValue]
  final double enemyUnitsSpeed;

  final double minValue;

  final double maxValue;

  _DataIsLoaded({
    required this.music,
    required this.sounds,
    required this.myUnitsSpeed,
    required this.enemyUnitsSpeed,
    required this.minValue,
    required this.maxValue,
  });

  _DataIsLoaded copy({double? music, double? sounds, double? myUnitsSpeed, double? enemyUnitsSpeed}) =>
      _DataIsLoaded(
        music: music ?? this.music,
        sounds: sounds ?? this.sounds,
        myUnitsSpeed: myUnitsSpeed ?? this.myUnitsSpeed,
        enemyUnitsSpeed: enemyUnitsSpeed ?? this.enemyUnitsSpeed,
        minValue: minValue,
        maxValue: maxValue,
      );
}
