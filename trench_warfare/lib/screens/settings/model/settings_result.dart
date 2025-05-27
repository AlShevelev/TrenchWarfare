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

class SettingsResult {
  /// [SettingsConstants.minValue - SettingsConstants.maxValue]
  final double music;

  /// [SettingsConstants.minValue - SettingsConstants.maxValue]
  final double sounds;

  /// [SettingsConstants.minValue - SettingsConstants.maxValue]
  final double humanUnitsSpeed;

  /// [SettingsConstants.minValue - SettingsConstants.maxValue]
  final double aiUnitsSpeed;

  SettingsResult({
    required this.music,
    required this.sounds,
    required this.humanUnitsSpeed,
    required this.aiUnitsSpeed,
  });
}
