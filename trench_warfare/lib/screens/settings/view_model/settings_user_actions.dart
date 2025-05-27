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

abstract interface class _SettingsUserActions {
  SettingsResult get settingsValue;

  void onMusicUpdated(double value);

  void onSoundsUpdated(double value);

  void onMyUnitsSpeedUpdated(double value);

  void onEnemyUnitsSpeedUpdated(double value);
}