import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_gdx_texture_packer/flame_gdx_texture_packer.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/components/game_field_components_library.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/game_objects_composer.dart';
import 'package:trench_warfare/screens/game_field_screen/view_model/game_field_view_model.dart';

class GameField extends FlameGame with ScaleDetector, TapDetector {
  late final GameFieldViewModel _viewModel;

  late TiledComponent mapComponent;

  static const double _minZoom = 0.5;
  static const double _maxZoom = 2.0;
  double _startZoom = _minZoom;

  late final String _mapName;

  late final GameObjectsComposer _gameObjectsComposer;

  GameField({required mapName}) : super() {
    _mapName = mapName;
    _viewModel = GameFieldViewModel();
  }

  @override
  Color backgroundColor() => const Color(0x00000000); // Must be transparent to show the background

  @override
  Future<void> onLoad() async {
    camera.viewfinder
      ..zoom = _startZoom
      ..anchor = Anchor.center;

    mapComponent = await TiledComponent.load(
      _mapName,
      ComponentConstants.cellRealSize,
    );
    world.add(mapComponent);

    _checkBorders();

    _gameObjectsComposer = GameObjectsComposer(
      mapComponent,
      _viewModel.updateGameObjectsEvent,
      await fromAtlas('images/sprites/sprites_atlas'),
      _viewModel.onMovementComplete,
      explosionAnimationAtlas: await images.load('sprites/animation_explosion_atlas.png'),
      bloodSplashesAnimationAtlas: await images.load('sprites/animation_blood_splashes_atlas.png'),
    );

    await _viewModel.init(mapComponent.tileMap);

    _gameObjectsComposer.init(_viewModel.gameField);
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

  @override
  void onDispose() {
    _gameObjectsComposer.dispose();
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
}
