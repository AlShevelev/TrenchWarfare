/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

abstract interface class SettingsStorageRead {
  double get music;

  double get sounds;

  double get humanUnitsSpeed;

  double get aiUnitsSpeed;

  bool get showBorders;

  bool get showDebugInfo;
}