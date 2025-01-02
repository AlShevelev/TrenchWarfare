import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_gdx_texture_packer/atlas/texture_atlas.dart';
import 'package:flame_gdx_texture_packer/flame_gdx_texture_packer.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:trench_warfare/app/navigation/navigation_library.dart';
import 'package:trench_warfare/audio/audio_library.dart';
import 'package:trench_warfare/core/enums/game_slot.dart';
import 'package:trench_warfare/core/enums/nation.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/game_field_state.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/update_game_event.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/composers/audio/audio_composer.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/composers/gestures/game_gestures_composer_library.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/composers/gestures/zoom_constants.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/game_object_components/game_field_components_library.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/game_field_controls.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/composers/game_objects/game_objects_composer.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/game_field_controls/game_field_controls_library.dart';
import 'package:trench_warfare/screens/game_field_screen/view_model/game_field_view_model.dart';
import 'package:trench_warfare/screens/settings/settings_library.dart';
import 'package:trench_warfare/shared/helpers/extensions.dart';
import 'package:trench_warfare/shared/logger/logger_library.dart';

abstract interface class GameFieldForControls {
  Stream<GameFieldControlsState> get controlsState;

  TextureAtlas get spritesAtlas;

  void onResortUnits(int cellId, Iterable<String> unitsId, {required bool isCarrier});

  void onCardsButtonClick();

  void onEndOfTurnButtonClick();

  void onMenuButtonClick();

  void onCardSelected(GameFieldControlsCard? card);

  void onCancelled();

  void onCardsPlacingCancelled();

  void onPopupDialogClosed();

  void onPhoneBackAction();

  void onMenuQuitButtonClick();

  void onMenuObjectivesButtonClick();

  void onMenuSaveButtonClick();

  void onMenuSettingsButtonClick();

  void onSaveSlotSelected(GameSlot slot);

  void onSettingsClosed(SettingsResult result);
}

class GameField extends FlameGame
    with ScaleDetector, TapDetector, HasGameRef
    implements GameFieldForControls {
  late final GameFieldViewModel _viewModel;

  late TiledComponent _mapComponent;

  late final String _mapFileName;

  late final Nation? _selectedNation;
  late final GameSlot? _slot;

  late final AudioComposer _audioComposer;
  late final GameObjectsComposer _gameObjectsComposer;
  late final GameGesturesComposer _gameGesturesComposer;

  StreamSubscription? _updateGameObjectsSubscription;
  StreamSubscription? _gameFieldStateSubscription;

  @override
  Stream<GameFieldControlsState> get controlsState => _viewModel.controlsState;

  late final TextureAtlas _spritesAtlas;
  @override
  TextureAtlas get spritesAtlas => _spritesAtlas;

  GameField({required String mapFileName, Nation? selectedNation, GameSlot? slot})
      : _mapFileName = mapFileName,
        _selectedNation = selectedNation,
        _slot = slot,
        _viewModel = GameFieldViewModel(),
        super();

  @override
  Color backgroundColor() => const Color(0x00000000); // Must be transparent to show the background

  @override
  Future<void> onLoad() async {
    camera.viewfinder
      ..zoom = ZoomConstants.startZoom
      ..anchor = Anchor.center;

    _mapComponent = await TiledComponent.load(
      _mapFileName.replaceFirst('assets/tiles/', ''),
      ComponentConstants.cellRealSize,
    );
    world.add(_mapComponent);

    _updateGameObjectsSubscription = _viewModel.updateGameObjectsEvent.listen(_onUpdateGameEvent);
    _gameFieldStateSubscription = _viewModel.gameFieldState.listen(_onGameFieldStateUpdate);

    _gameGesturesComposer = GameGesturesComposer(
      mapSize: Offset(_mapComponent.width, _mapComponent.height),
      camera: GesturesCamera(camera),
    );

    _spritesAtlas = await fromAtlas('images/sprites/sprites_atlas');

    _audioComposer = AudioComposer();

    _gameObjectsComposer = GameObjectsComposer(
      _mapComponent,
      _spritesAtlas,
      animationAtlas: await images.load('sprites/animation.webp'),
    );

    if (_slot == null) {
      await _viewModel.initNewGame(
        tileMap: _mapComponent.tileMap,
        selectedNation: _selectedNation!,
        mapFileName: _mapFileName,
      );
    } else {
      await _viewModel.initLoadGame(slot: _slot!);
    }

    _gameObjectsComposer.init(_viewModel.gameField, _viewModel);
    _gameGesturesComposer.init(_viewModel);

    overlays.add(GameFieldControls.overlayKey);
  }

  @override
  void onAttach() {
    _audioComposer.setAudioController(gameRef.buildContext?.read<AudioController>());
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
      _viewModel.input.onResortUnits(cellId, unitsId, isCarrier: isCarrier);

  @override
  void onDispose() {
    _updateGameObjectsSubscription?.cancel();
    _gameFieldStateSubscription?.cancel();
    _viewModel.dispose();
    super.onDispose();
  }

  void _onUpdateGameEvent(Iterable<UpdateGameEvent> events) async {
    for (var event in events) {
      _audioComposer.onUpdateGameEvent(event);
      await _gameObjectsComposer.onUpdateGameEvent(event);
      await _gameGesturesComposer.onUpdateGameEvent(event);
    }
  }

  void _onGameFieldStateUpdate(GameFieldState state) async {
    if (state is Completed) {
      Logger.info('pop to the cover screen', tag: 'NAVIGATION');
      gameRef.buildContext?.let((context) => Navigator.of(context).pushNamedAndRemoveUntil(
            Routes.cover,
            (r) => false,
          ));
    }
  }

  @override
  void onCardsButtonClick() => _viewModel.input.onCardsButtonClick();

  @override
  void onCancelled() => _viewModel.input.onCancelled();

  @override
  void onCardSelected(GameFieldControlsCard? card) => _viewModel.input.onCardSelected(card);

  @override
  void onCardsPlacingCancelled() => _viewModel.input.onCardsPlacingCancelled();

  @override
  void onEndOfTurnButtonClick() => _viewModel.input.onEndOfTurnButtonClick();

  @override
  void onPopupDialogClosed() => _viewModel.input.onPopupDialogClosed();

  @override
  void onMenuButtonClick() => _viewModel.input.onMenuButtonClick();

  @override
  void onPhoneBackAction() => _viewModel.input.onPhoneBackAction();

  @override
  void onMenuQuitButtonClick() => _viewModel.input.onMenuQuitButtonClick();

  @override
  void onMenuObjectivesButtonClick() => _viewModel.input.onMenuObjectivesButtonClick();

  @override
  void onMenuSaveButtonClick() => _viewModel.input.onMenuSaveButtonClick();

  @override
  void onMenuSettingsButtonClick() => _viewModel.input.onMenuSettingsButtonClick();

  @override
  void onSaveSlotSelected(GameSlot slot) => _viewModel.input.onSaveSlotSelected(slot);

  @override
  void onSettingsClosed(SettingsResult result) => _viewModel.input.onSettingsClosed(result);
}
