/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of game_gesture_composer;

class GesturesCamera {
  late final CameraComponent _camera;

  double get zoom => _camera.viewfinder.zoom;

  Vector2 get position => _camera.viewfinder.position;

  Rect get visibleRect => _camera.visibleWorldRect;

  Vector2 get viewPortSize => _camera.viewport.size;

  GesturesCamera(CameraComponent camera) {
    _camera = camera;
  }

  void updatePosition(Vector2 position) => _camera.viewfinder.position = position;

  void updateZoom(double zoom) => _camera.viewfinder.zoom = zoom;

  Vector2 globalPositionToLocal(Vector2 globalPosition) => _camera.globalToLocal(globalPosition);
}