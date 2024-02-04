import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_gdx_texture_packer/atlas/texture_atlas.dart';
import 'package:flame_gdx_texture_packer/flame_gdx_texture_packer.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/foundation.dart';
import 'package:trench_warfare/core_entities/entities/game_field_cell.dart';
import 'package:trench_warfare/core_entities/entities/game_objects/game_object.dart';
import 'package:trench_warfare/screens/game_field_screen/model/update_game_event.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/components/game_field_components_library.dart';
import 'package:trench_warfare/screens/game_field_screen/view_model/game_field_view_model.dart';

class GameField extends FlameGame with ScaleDetector, TapDetector {
  late final GameFieldViewModel _viewModel;

  late TiledComponent mapComponent;

  static const double _minZoom = 0.5;
  static const double _maxZoom = 2.0;
  double _startZoom = _minZoom;

  late final String _mapName;

  late final TextureAtlas _spritesAtlas;
  late final Image _animationAtlas;

  StreamSubscription? _updateGameObjectsSubscription;

  final Map<UniqueKey, GameObjectComponentBase> _gameObjects = {};

  GameField({required mapName}) : super() {
    _mapName = mapName;
    _viewModel = GameFieldViewModel();
  }

  @override
  Color backgroundColor() => const Color(0x00000000); // Must be transparent to show the background

  @override
  Future<void> onLoad() async {
    _spritesAtlas = await fromAtlas('images/sprites/sprites_atlas');
    _animationAtlas = await images.load('sprites/animation_atlas.png');

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

  void onUpdateGameEvent(Iterable<UpdateGameEvent> events) async {
    for (var event in events) {
      switch (event) {
        case UpdateObject(cell: var cell):
          _updateCell(cell);

        case CreateUntiedUnit(cell: var cell, unit: var unit):
          _createUntiedUnit(cell, unit);

        case RemoveUntiedUnit(unit: var unit):
          _removeUntiedUnit(unit);

        case MoveUntiedUnit(startCell: var startCell, endCell: var endCell, unit: var unit, time: var time):
          await _moveUntiedUnit(startCell, endCell, unit, time);

        case Pause(time: var time):
          await _pause(time);

        case ShowExplosion(unit: var unit, time: var time):
          await _showExplosion(unit, time);

        case MovementCompleted():
          _viewModel.onMovementComplete();
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
    _removeGameObject(cell.id);

    final gameObject = GameObjectCell(
      spritesAtlas: _spritesAtlas,
      cell: cell,
    );

    _addGameObject(gameObject, cell.id);
  }

  void _createUntiedUnit(GameFieldCell cell, Unit unit) {
    final gameObject = GameObjectUntiedUnit(
      spritesAtlas: _spritesAtlas,
      position: cell.center,
      unit: unit,
      nation: cell.nation!,
    );

    _addGameObject(gameObject, unit.id);
  }

  void _removeUntiedUnit(Unit unit) {
    _removeGameObject(unit.id);
  }

  Future<void> _moveUntiedUnit(GameFieldCell startCell, GameFieldCell endCell, Unit unit, int time) async {
    final unitSprite = _gameObjects[unit.id];

    if (unitSprite == null) {
      return;
    }

    final effect = MoveToEffect(endCell.center, EffectController(duration: _millisecondsToSeconds(time)));
    unitSprite.add(effect);

    await Future.delayed(Duration(milliseconds: time));
  }

  Future<void> _pause(int time) async {
    await Future.delayed(Duration(milliseconds: time));
  }

  Future<void> _showExplosion(Unit unit, int time) async {
    final unitSprite = _gameObjects[unit.id];

    if (unitSprite == null) {
      return;
    }

    final timeInSeconds = _millisecondsToSeconds(time);

    final animationComponent = AnimationFrameToFrameComponent(
      animationAtlas: _animationAtlas,
      stepTime: timeInSeconds / 8,
      position: unitSprite.position,
    );

    animationComponent.add(RemoveEffect(delay: timeInSeconds));

    mapComponent.add(animationComponent);

    await Future.delayed(Duration(milliseconds: time));
  }

  void _addGameObject(GameObjectComponentBase gameObject, UniqueKey id) {
    mapComponent.add(gameObject);
    _gameObjects[id] = gameObject;
  }

  void _removeGameObject(UniqueKey id) {
    final gameObject = _gameObjects.remove(id);

    if (gameObject != null) {
      mapComponent.remove(gameObject);
    }
  }

  double _millisecondsToSeconds(int time) => 1 / 1000 * time;
}
