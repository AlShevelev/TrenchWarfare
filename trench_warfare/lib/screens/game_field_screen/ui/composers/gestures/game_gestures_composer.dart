part of game_gesture_composer;

class GameGesturesComposer {
  static const double minZoom = 0.5;
  static const double maxZoom = 2.0;

  static const int longTapDuration = 1000; // ms

  double _zoom = minZoom;
  double get zoom => _zoom;

  late final GesturesCamera _camera;

  late final void Function(GestureEvent) _onGestureEvent;

  late final Offset _mapSize;

  Vector2? _tapPosition;
  bool _longTapStarted = false;

  GameGesturesComposer({
    required Offset mapSize,
    required GesturesCamera camera,
    required void Function(GestureEvent) onGestureEvent,
  }) {
    _mapSize = mapSize;
    _camera = camera;

    _onGestureEvent = onGestureEvent;

    _checkBorders();
  }

  void onScaleStart() => _zoom = _camera.zoom;

  void onScaleUpdate({required Vector2 currentScale, required Vector2 scaleDelta}) {
    if (currentScale.isIdentity()) {
      // One-finger gesture
      _processDrag(scaleDelta: scaleDelta, cameraPosition: _camera.position);
    } else {
      // Several fingers gesture
      _processScale(currentScale);
    }
  }

  void onScaleEnd() => _checkBorders();

  Future<void> onTapStart(Vector2 position) async {
    if (_tapPosition != null) {
      return;
    }

    _tapPosition = _camera.globalPositionToLocal(position);
    _longTapStarted = false;

    await Future.delayed(const Duration(milliseconds: longTapDuration));

    final tapPosition = _tapPosition;
    if (tapPosition != null) {
      _longTapStarted = true;
      _onGestureEvent(LongTap(tapPosition));
    }
  }

  void onTapEnd() {
    final position = _tapPosition;
    _tapPosition = null;

    if (position != null) {
      if (_longTapStarted) {
        _onGestureEvent(LongTapCompleted());
      } else {
        _onGestureEvent(Tap(position));
      }
    }

    _tapPosition = null;
    _longTapStarted = false;
  }

  void _checkBorders() {
    _checkScaleBorders(_camera.zoom);
    _checkDragBorders(_camera.visibleRect, _camera.position);
  }

  void _processDrag({required Vector2 scaleDelta, required Vector2 cameraPosition}) {
    final zoomDragFactor = 1.0 / _zoom; // To synchronize a drag distance with current zoom value

    _camera.updatePosition(cameraPosition.translated(
      -scaleDelta.x * zoomDragFactor,
      -scaleDelta.y * zoomDragFactor,
    ));
  }

  void _processScale(Vector2 currentScale) {
    final newZoom = _zoom * ((currentScale.y + currentScale.x) / 2.0);
    _camera.updateZoom(newZoom.clamp(minZoom, maxZoom));
  }

  void _checkScaleBorders(double currentZoom) => _camera.updateZoom(currentZoom.clamp(minZoom, maxZoom));

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

    _camera.updatePosition(cameraPosition.translated(xTranslate, yTranslate));
  }
}
