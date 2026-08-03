/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

import 'package:trench_warfare/shared/data/settings/settings_storage_read.dart';

class SettingsStorageReadStubImpl implements SettingsStorageRead {
  @override
  double get aiUnitsSpeed => 0;

  @override
  double get humanUnitsSpeed => 0;

  @override
  double get music => 0;

  @override
  bool get showBorders => false;

  @override
  bool get showDebugInfo => false;

  @override
  double get sounds => 0;
}