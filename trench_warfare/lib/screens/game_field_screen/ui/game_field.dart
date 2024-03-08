import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_gdx_texture_packer/flame_gdx_texture_packer.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/game_gestures_composer.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/game_object_components/game_field_components_library.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/game_field_controls.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/game_objects_composer.dart';
import 'package:trench_warfare/screens/game_field_screen/view_model/game_field_controls_state.dart';
import 'package:trench_warfare/screens/game_field_screen/view_model/game_field_view_model.dart';

class GameField extends FlameGame with ScaleDetector, TapDetector {
  late final GameFieldViewModel _viewModel;

  late TiledComponent mapComponent;

  late final String _mapName;

  late final GameObjectsComposer _gameObjectsComposer;
  late final GameGesturesComposer _gameGesturesComposer;

  Stream<GameFieldControlsState> get controlsState => _viewModel.controlsState;

  GameField({required mapName}) : super() {
    _mapName = mapName;
    _viewModel = GameFieldViewModel();
  }

  @override
  Color backgroundColor() => const Color(0x00000000); // Must be transparent to show the background

  @override
  Future<void> onLoad() async {
    camera.viewfinder
      ..zoom = GameGesturesComposer.minZoom
      ..anchor = Anchor.center;

    mapComponent = await TiledComponent.load(
      _mapName,
      ComponentConstants.cellRealSize,
    );
    world.add(mapComponent);

    _gameGesturesComposer = GameGesturesComposer(
      mapSize: Offset(mapComponent.width, mapComponent.height),
      onCameraPositionUpdate: _onCameraPositionUpdate,
      onCameraZoomUpdate: _onCameraZoomUpdate,
    );

    _gameGesturesComposer.checkBorders(
      currentZoom: camera.viewfinder.zoom,
      visibleWorldRect: camera.visibleWorldRect,
      cameraPosition: camera.viewfinder.position,
    );

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

    overlays.add(GameFieldControls.overlayKey);
  }

  @override
  void onScaleStart(ScaleStartInfo info) => _gameGesturesComposer.onScaleStart(camera.viewfinder.zoom);

  @override
  void onScaleUpdate(ScaleUpdateInfo info) =>
    _gameGesturesComposer.onScaleUpdate(
      currentScale: info.scale.global,
      scaleDelta: info.delta.global,
      cameraPosition: camera.viewfinder.position,
    );

  @override
  void onScaleEnd(ScaleEndInfo info) =>
    _gameGesturesComposer.checkBorders(
      currentZoom: camera.viewfinder.zoom,
      visibleWorldRect: camera.visibleWorldRect,
      cameraPosition: camera.viewfinder.position,
    );

  @override
  Future<void> onTapUp(TapUpInfo info) async => _viewModel.onClick(camera.globalToLocal(info.eventPosition.global));

  @override
  void onDispose() {
    _gameObjectsComposer.dispose();
    _viewModel.dispose();
    super.onDispose();
  }

  void _onCameraPositionUpdate(Vector2 newPosition) => camera.viewfinder.position = newPosition;

  void _onCameraZoomUpdate(double newZoom) => camera.viewfinder.zoom = newZoom;
}
