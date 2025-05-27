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
