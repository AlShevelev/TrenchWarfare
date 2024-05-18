import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_gdx_texture_packer/atlas/texture_atlas.dart';
import 'package:flame_gdx_texture_packer/flame_gdx_texture_packer.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/update_game_event.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/composers/gestures/game_gestures_composer_library.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/game_object_components/game_field_components_library.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/game_field_controls.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/composers/game_objects/game_objects_composer.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/game_field_controls/game_field_controls_library.dart';
import 'package:trench_warfare/screens/game_field_screen/view_model/game_field_view_model.dart';

abstract interface class GameFieldForControls {
  Stream<GameFieldControlsState> get controlsState;

  TextureAtlas get spritesAtlas;

  void onResortUnits(int cellId, Iterable<String> unitsId, {required bool isCarrier});

  void onCardsButtonClick();

  void onEndOfTurnButtonClick();

  void onCardSelected(GameFieldControlsCard? card);

  void onCardsSelectionCancelled();

  void onCardsPlacingCancelled();
}

class GameField extends FlameGame with ScaleDetector, TapDetector implements GameFieldForControls {
  late final GameFieldViewModel _viewModel;

  late TiledComponent _mapComponent;

  late final String _mapName;

  late final GameObjectsComposer _gameObjectsComposer;
  late final GameGesturesComposer _gameGesturesComposer;

  StreamSubscription? _updateGameObjectsSubscription;

  @override
  Stream<GameFieldControlsState> get controlsState => _viewModel.controlsState;

  late final TextureAtlas _spritesAtlas;
  @override
  TextureAtlas get spritesAtlas => _spritesAtlas;

  GameField({required mapName}) : super() {
    _mapName = mapName;
    _viewModel = GameFieldViewModel();
  }

  @override
  Color backgroundColor() => const Color(0x00000000); // Must be transparent to show the background

  @override
  Future<void> onLoad() async {
    camera.viewfinder
      ..zoom = GameGesturesComposer.startZoom
      ..anchor = Anchor.center;

    _mapComponent = await TiledComponent.load(
      _mapName,
      ComponentConstants.cellRealSize,
    );
    world.add(_mapComponent);

    _updateGameObjectsSubscription = _viewModel.updateGameObjectsEvent.listen(_onUpdateGameEvent);

    _gameGesturesComposer = GameGesturesComposer(
      mapSize: Offset(_mapComponent.width, _mapComponent.height),
      camera: GesturesCamera(camera),
      onGestureEvent: _onGestureEvent,
    );

    _spritesAtlas = await fromAtlas('images/sprites/sprites_atlas');

    _gameObjectsComposer = GameObjectsComposer(
      _mapComponent,
      _spritesAtlas,
      _viewModel.onAnimationComplete,
      animationAtlas: await images.load('sprites/animation.webp'),
    );

    await _viewModel.init(_mapComponent.tileMap);

    _gameObjectsComposer.init(_viewModel.gameField);

    overlays.add(GameFieldControls.overlayKey);
  }

  @override
  void onScaleStart(ScaleStartInfo info) => _gameGesturesComposer.onScaleStart();

  @override
  void onScaleUpdate(ScaleUpdateInfo info) => _gameGesturesComposer.onScaleUpdate(
        currentScale: info.scale.global,
        scaleDelta: info.delta.global,
      );

  @override
  void onScaleEnd(ScaleEndInfo info) => _gameGesturesComposer.onScaleEnd();

  @override
  void onTapDown(TapDownInfo info) => _gameGesturesComposer.onTapStart(info.eventPosition.global);

  @override
  void onTapUp(TapUpInfo info) => _gameGesturesComposer.onTapEnd();

  @override
  void onTapCancel() => _gameGesturesComposer.onTapEnd();

  @override
  void onResortUnits(int cellId, Iterable<String> unitsId, {required bool isCarrier}) =>
      _viewModel.onResortUnits(cellId, unitsId, isCarrier: isCarrier);

  @override
  void onDispose() {
    _updateGameObjectsSubscription?.cancel();
    _viewModel.dispose();
    super.onDispose();
  }

  void _onUpdateGameEvent(Iterable<UpdateGameEvent> events) async {
    for (var event in events) {
      await _gameObjectsComposer.onUpdateGameEvent(event);
      await _gameGesturesComposer.onUpdateGameEvent(event);
    }
  }

  void _onGestureEvent(GestureEvent event) {
    switch (event) {
      case Tap(position: var position):
        _viewModel.onClick(position);
      case LongTap(position: var position):
        _viewModel.onLongClickStart(position);
      case LongTapCompleted():
        _viewModel.onLongClickEnd();
      case CameraUpdated(zoom: var zoom, position: var position):
        _viewModel.onCameraUpdated(zoom, position);
    }
  }

  @override
  void onCardsButtonClick() => _viewModel.onCardsButtonClick();

  @override
  void onCardsSelectionCancelled() => _viewModel.onCardsSelectionCancelled();

  @override
  void onCardSelected(GameFieldControlsCard? card) => _viewModel.onCardSelected(card);

  @override
  void onCardsPlacingCancelled() => _viewModel.onCardsPlacingCancelled();

  @override
  void onEndOfTurnButtonClick() => _viewModel.onEndOfTurnButtonClick();
}
