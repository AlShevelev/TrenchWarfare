part of settings;

class SettingsResult {
  /// [SettingsConstants.minValue - SettingsConstants.maxValue]
  final double music;

  /// [SettingsConstants.minValue - SettingsConstants.maxValue]
  final double sounds;

  /// [SettingsConstants.minValue - SettingsConstants.maxValue]
  final double myUnitsSpeed;

  /// [SettingsConstants.minValue - SettingsConstants.maxValue]
  final double enemyUnitsSpeed;

  SettingsResult({
    required this.music,
    required this.sounds,
    required this.myUnitsSpeed,
    required this.enemyUnitsSpeed,
  });
}
