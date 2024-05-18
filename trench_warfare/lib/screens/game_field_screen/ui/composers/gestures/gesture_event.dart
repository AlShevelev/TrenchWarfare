part of game_gesture_composer;

sealed class GestureEvent {}

class Tap implements GestureEvent {
  final Vector2 position;

  Tap(this.position);
}

class LongTap implements GestureEvent {
  final Vector2 position;
  LongTap(this.position);
}

class LongTapCompleted implements GestureEvent {}

class CameraUpdated implements GestureEvent {
  final double zoom;

  final Vector2 position;

  CameraUpdated(this.zoom, this.position);
}
