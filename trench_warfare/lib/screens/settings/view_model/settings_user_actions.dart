part of settings;

abstract interface class _SettingsUserActions {
  SettingsResult get settingsValue;

  void onMusicUpdated(double value);

  void onSoundsUpdated(double value);

  void onMyUnitsSpeedUpdated(double value);

  void onEnemyUnitsSpeedUpdated(double value);
}