part of game_gesture_composer;

class GesturesCamera {
  late final CameraComponent _camera;

  double get zoom => _camera.viewfinder.zoom;

  Vector2 get position => _camera.viewfinder.position;

  Rect get visibleRect => _camera.visibleWorldRect;

  GesturesCamera(CameraComponent camera) {
    _camera = camera;
  }

  void updatePosition(Vector2 position) => _camera.viewfinder.position = position;

  void updateZoom(double zoom) => _camera.viewfinder.zoom = zoom;

  Vector2 globalPositionToLocal(Vector2 globalPosition) => _camera.globalToLocal(globalPosition);
}