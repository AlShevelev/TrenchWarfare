import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_gdx_texture_packer/atlas/texture_atlas.dart';
import 'package:flame_gdx_texture_packer/flame_gdx_texture_packer.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:trench_warfare/core_entities/entities/game_field_cell.dart';
import 'package:trench_warfare/screens/game_field_screen/model/update_game_event.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/game_field_cell_component.dart';
import 'package:trench_warfare/screens/game_field_screen/view_model/game_field_view_model.dart';

class GameField extends FlameGame with ScaleDetector, TapDetector {
  late final GameFieldViewModel _viewModel;

  late TiledComponent mapComponent;

  static const double _minZoom = 0.5;
  static const double _maxZoom = 2.0;
  double _startZoom = _minZoom;

  late final String _mapName;

  late final TextureAtlas _spritesAtlas;

  StreamSubscription? _updateGameObjectsSubscription;

  final Map<int, GameFieldCellComponent> _cellComponent = {};

  GameField({required mapName}) : super() {
    _mapName = mapName;
    _viewModel = GameFieldViewModel();
  }

  @override
  Color backgroundColor() => const Color(0x00000000); // Must be transparent to show the background

  @override
  Future<void> onLoad() async {
    _spritesAtlas = await fromAtlas('images/sprites/sprites_atlas');

    camera.viewfinder
      ..zoom = _startZoom
      ..anchor = Anchor.center;

    mapComponent = await TiledComponent.load(
      _mapName,
      Vector2(64, 73), // Should be as same as a size of tile in the Tiled
    );
    world.add(mapComponent);

    _checkBorders();

    _updateGameObjectsSubscription = _viewModel.updateGameObjectsEvent.listen(onUpdateGameEvent);

    await _viewModel.init(mapComponent.tileMap);
  }

  @override
  void onScaleStart(ScaleStartInfo info) {
    _startZoom = camera.viewfinder.zoom;
  }

  @override
  void onScaleUpdate(ScaleUpdateInfo info) {
    final currentScale = info.scale.global;

    if (currentScale.isIdentity()) {
      // One-finger gesture
      _processDrag(info);
    } else {
      // Several fingers gesture
      _processScale(info, currentScale);
    }
  }

  @override
  void onScaleEnd(ScaleEndInfo info) {
    _checkBorders();
  }

  @override
  Future<void> onTapUp(TapUpInfo info) async {
    _viewModel.onClick(camera.globalToLocal(info.eventPosition.global));
  }

  void onUpdateGameEvent(Iterable<UpdateGameEvent> events) {
    for (var event in events) {
      switch (event) {
        case UpdateObject(cell: var cell):
          _updateCell(cell);
      }
    }
  }

  @override
  void onDispose() {
    _updateGameObjectsSubscription?.cancel();
    _viewModel.dispose();
    super.onDispose();
  }

  void _checkBorders() {
    _checkScaleBorders();
    _checkDragBorders();
  }

  void _processDrag(ScaleUpdateInfo info) {
    final delta = info.delta.global;
    final zoomDragFactor = 1.0 / _startZoom; // To synchronize a drag distance with current zoom value
    final currentPosition = camera.viewfinder.position;

    camera.viewfinder.position = currentPosition.translated(
      -delta.x * zoomDragFactor,
      -delta.y * zoomDragFactor,
    );
  }

  void _processScale(ScaleUpdateInfo info, Vector2 currentScale) {
    final newZoom = _startZoom * ((currentScale.y + currentScale.x) / 2.0);
    camera.viewfinder.zoom = newZoom.clamp(_minZoom, _maxZoom);
  }

  void _checkScaleBorders() {
    camera.viewfinder.zoom = camera.viewfinder.zoom.clamp(_minZoom, _maxZoom);
  }

  void _checkDragBorders() {
    final worldRect = camera.visibleWorldRect;

    final currentPosition = camera.viewfinder.position;

    final mapSize = Offset(mapComponent.width, mapComponent.height);

    var xTranslate = 0.0;
    var yTranslate = 0.0;

    if (worldRect.topLeft.dx < 0.0) {
      xTranslate = -worldRect.topLeft.dx;
    } else if (worldRect.bottomRight.dx > mapSize.dx) {
      xTranslate = mapSize.dx - worldRect.bottomRight.dx;
    }

    if (worldRect.topLeft.dy < 0.0) {
      yTranslate = -worldRect.topLeft.dy;
    } else if (worldRect.bottomRight.dy > mapSize.dy) {
      yTranslate = mapSize.dy - worldRect.bottomRight.dy;
    }

    camera.viewfinder.position = currentPosition.translated(xTranslate, yTranslate);
  }

  void _updateCell(GameFieldCell cell) {
    final oldComponent = _cellComponent.remove(cell.id);

    if (oldComponent != null) {
      mapComponent.remove(oldComponent);
    }

    final newComponent = GameFieldCellComponent(
      baseSize: Vector2.all(64.0),
      spritesAtlas: _spritesAtlas,
      cell: cell,
      position: Vector2(cell.center.dx, cell.center.dy),
    );

    mapComponent.add(newComponent);

    _cellComponent[cell.id] = newComponent;
  }
}
