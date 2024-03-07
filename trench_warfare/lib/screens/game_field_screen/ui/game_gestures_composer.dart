import 'dart:ui';

import 'package:flame/components.dart';

class GameGesturesComposer {
  static const double minZoom = 0.5;
  static const double maxZoom = 2.0;

  double _zoom = minZoom;
  double get zoom => _zoom;

  late final void Function(Vector2) _onCameraPositionUpdate;
  late final void Function(double) _onCameraZoomUpdate;

  late final Offset _mapSize;

  GameGesturesComposer({
    required Offset mapSize,
    required void Function(Vector2) onCameraPositionUpdate,
    required void Function(double) onCameraZoomUpdate,
  }) {
    _mapSize = mapSize;

    _onCameraPositionUpdate = onCameraPositionUpdate;
    _onCameraZoomUpdate = onCameraZoomUpdate;
  }

  void onScaleStart(double currentZoom) => _zoom = currentZoom;

  void onScaleUpdate({required Vector2 currentScale, required Vector2 scaleDelta, required Vector2 cameraPosition}) {
    if (currentScale.isIdentity()) {
      // One-finger gesture
      _processDrag(scaleDelta: scaleDelta, cameraPosition: cameraPosition);
    } else {
      // Several fingers gesture
      _processScale(currentScale);
    }
  }

  void checkBorders({required double currentZoom, required Rect visibleWorldRect, required Vector2 cameraPosition}) {
    _checkScaleBorders(currentZoom);
    _checkDragBorders(visibleWorldRect, cameraPosition);
  }

  void _processDrag({required Vector2 scaleDelta, required Vector2 cameraPosition}) {
    final zoomDragFactor = 1.0 / _zoom; // To synchronize a drag distance with current zoom value

    _onCameraPositionUpdate(cameraPosition.translated(
      -scaleDelta.x * zoomDragFactor,
      -scaleDelta.y * zoomDragFactor,
    ));
  }

  void _processScale(Vector2 currentScale) {
    final newZoom = _zoom * ((currentScale.y + currentScale.x) / 2.0);
    _onCameraZoomUpdate(newZoom.clamp(minZoom, maxZoom));
  }

  void _checkScaleBorders(double currentZoom) {
    _onCameraZoomUpdate(currentZoom.clamp(minZoom, maxZoom));
  }

  void _checkDragBorders(Rect visibleWorldRect, Vector2 cameraPosition) {
    final worldRect = visibleWorldRect;

    var xTranslate = 0.0;
    var yTranslate = 0.0;

    if (worldRect.topLeft.dx < 0.0) {
      xTranslate = -worldRect.topLeft.dx;
    } else if (worldRect.bottomRight.dx > _mapSize.dx) {
      xTranslate = _mapSize.dx - worldRect.bottomRight.dx;
    }

    if (worldRect.topLeft.dy < 0.0) {
      yTranslate = -worldRect.topLeft.dy;
    } else if (worldRect.bottomRight.dy > _mapSize.dy) {
      yTranslate = _mapSize.dy - worldRect.bottomRight.dy;
    }

    _onCameraPositionUpdate(cameraPosition.translated(xTranslate, yTranslate));
  }
}
