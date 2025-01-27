part of game_gesture_composer;

class GameGesturesComposer {
  static const int longTapDuration = 700; // ms

  double _zoom = ZoomConstants.startZoom;

  late final GesturesCamera _camera;

  late final Offset _mapSize;

  late final double _minZoom;

  Vector2? _tapPosition;
  bool _longTapStarted = false;

  late final GameFieldViewModelInput _viewModelInput;

  GameGesturesComposer({
    required Offset mapSize,
    required GesturesCamera camera,
  }) {
    _mapSize = mapSize;
    _camera = camera;

    _minZoom = _calculateMinZoom();

    _checkBorders();
  }

  void init(GameFieldViewModelInput viewModelInput) => _viewModelInput = viewModelInput;

  void onScaleStart() {
    if (!_viewModelInput.isHumanPlayer) {
      return;
    }

    _zoom = _camera.zoom;
  }

  void onScaleUpdate({required Vector2 currentScale, required Vector2 scaleDelta}) {
    if (!_viewModelInput.isHumanPlayer) {
      return;
    }

    if (currentScale.isIdentity()) {
      // One-finger gesture
      _processDrag(scaleDelta: scaleDelta, cameraPosition: _camera.position);
    } else {
      // Several fingers gesture
      _processScale(currentScale);
    }
  }

  void onScaleEnd() {
    if (!_viewModelInput.isHumanPlayer) {
      return;
    }

    _checkBorders();
    _viewModelInput.input.onCameraUpdated(_camera.zoom, _camera.position);
  }

  Future<void> onTapStart(Vector2 position) async {
    if (!_viewModelInput.isHumanPlayer) {
      return;
    }

    if (_tapPosition != null) {
      return;
    }

    _tapPosition = _camera.globalPositionToLocal(position);
    _longTapStarted = false;

    await Future.delayed(const Duration(milliseconds: longTapDuration));

    final tapPosition = _tapPosition;
    if (tapPosition != null) {
      _longTapStarted = true;
      _viewModelInput.input.onLongClickStart(tapPosition);
    }
  }

  void onTapEnd() {
    if (!_viewModelInput.isHumanPlayer) {
      return;
    }

    final position = _tapPosition;
    _tapPosition = null;

    if (position != null) {
      if (_longTapStarted) {
        _viewModelInput.input.onLongClickEnd();
      } else {
        _viewModelInput.input.onClick(position);
      }
    }

    _tapPosition = null;
    _longTapStarted = false;
  }

  Future<void> onUpdateGameEvent(UpdateGameEvent event) async {
    switch (event) {
      case SetCamera(zoom: var zoom, position: var position):
        {
          zoom?.let((z) => _camera.updateZoom(z));
          position?.let((p) => _camera.updatePosition(p));
          _checkBorders();
        }

      case MoveCameraToCell(cell: var cell):
        {
          _camera.updatePosition(cell.center);
          _checkBorders();
        }

      default:
        {}
    }
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
    _camera.updateZoom(newZoom.clamp(_minZoom, ZoomConstants.maxZoom));
  }

  void _checkScaleBorders(double currentZoom) =>
      _camera.updateZoom(currentZoom.clamp(_minZoom, ZoomConstants.maxZoom));

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

  /// The zoom level to inscribe a map to a screen
  double _calculateMinZoom() {
    final minZoomX = _camera.viewPortSize.x / _mapSize.dx;
    final minZoomY = _camera.viewPortSize.y / _mapSize.dy;

    return math.max(minZoomX, minZoomY);
  }
}
