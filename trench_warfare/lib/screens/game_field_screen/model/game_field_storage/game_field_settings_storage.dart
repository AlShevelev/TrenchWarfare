/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

import 'package:flame/components.dart';

abstract interface class GameFieldSettingsStorageRead {
  double? get zoom;

  Vector2? get cameraPosition;
}

class GameFieldSettingsStorage implements GameFieldSettingsStorageRead {
  double? _zoom;
  @override
  double? get zoom => _zoom;
  set zoom(double? value) => _zoom = value;

  Vector2? _cameraPosition;
  @override
  Vector2? get cameraPosition => _cameraPosition;
  set cameraPosition(Vector2? value) => _cameraPosition = value;
}