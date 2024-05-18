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