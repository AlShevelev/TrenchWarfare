import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_gdx_texture_packer/atlas/texture_atlas.dart';
import 'package:flame_gdx_texture_packer/flame_gdx_texture_packer.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/widgets.dart';
import 'package:trench_warfare/app/navigation/navigation_library.dart';
import 'package:trench_warfare/core/enums/game_slot.dart';
import 'package:trench_warfare/core/enums/nation.dart';
import 'package:trench_warfare/core/localization/app_locale.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/game_field_controls/game_field_controls_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/game_field_state.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/update_game_event.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/composers/game_objects/game_objects_composer.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/composers/gestures/game_gestures_composer_library.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/composers/gestures/zoom_constants.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/game_field.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/game_object_components/game_field_components_library.dart';
import 'package:trench_warfare/screens/settings/settings_library.dart';
import 'package:trench_warfare/screens/tutorials/ui/controls/tutorial_game_field_controls.dart';
import 'package:trench_warfare/screens/tutorials/ui/settings_storage_read_stub_impl.dart';
import 'package:trench_warfare/screens/tutorials/view_model/stub_game_field_view_model_input.dart';
import 'package:trench_warfare/screens/tutorials/view_model/tutorial_game_field_view_model.dart';
import 'package:trench_warfare/shared/data/settings/settings_storage_read.dart';
import 'package:trench_warfare/shared/utils/extensions.dart';

class TutorialGameField extends FlameGame with HasGameRef implements GameFieldForControls {
  late final TutorialGameFieldViewModel _viewModel;

  late TiledComponent _mapComponent;

  late final String _mapFileName;

  late final Nation? _selectedNation;

  final AppLocale _locale;

  late final SettingsStorageRead _settings;

  StreamSubscription? _updateGameObjectsSubscription;
  StreamSubscription? _gameFieldStateSubscription;

  late final TextureAtlas _spritesAtlas;

  @override
  TextureAtlas get spritesAtlas => _spritesAtlas;

  @override
  int get gameFieldId => hashCode;

  late final GameObjectsComposer _gameObjectsComposer;
  late final GameGesturesComposer _gameGesturesComposer;

  @override
  Stream<GameFieldControlsState> get controlsState => _viewModel.controlsState;

  @override
  Stream<GameFieldControlsState> get aiProgressState => _viewModel.aiProgressState;

  TutorialGameField({
    required String mapFileName,
    Nation? selectedNation,
    required AppLocale locale,
  })  : _mapFileName = mapFileName,
        _selectedNation = selectedNation,
        _locale = locale,
        super() {
    _viewModel = TutorialGameFieldViewModel();
  }

  @override
  Color backgroundColor() => const Color(0x00000000); // Must be transparent to show the background

  @override
  Future<void> onLoad() async {
    camera.viewfinder
      ..zoom = ZoomConstants.maxZoom
      ..anchor = Anchor.center;

    _mapComponent = await TiledComponent.load(
      _mapFileName.replaceFirst('assets/tiles/', ''),
      ComponentConstants.cellRealSize,
    );
    world.add(_mapComponent);

    _updateGameObjectsSubscription = _viewModel.updateGameObjectsEvent.listen(_onUpdateGameEvent);
    _gameFieldStateSubscription = _viewModel.gameFieldState.listen(_onGameFieldStateChange);

    _gameGesturesComposer = GameGesturesComposer(
      zoom: ZoomConstants.maxZoom,
      mapSize: Offset(_mapComponent.width, _mapComponent.height),
      camera: GesturesCamera(camera),
    );

    _spritesAtlas = await fromAtlas('images/sprites/sprites_atlas');

    _settings = SettingsStorageReadStubImpl();

    _gameObjectsComposer = GameObjectsComposer(
      _mapComponent,
      _spritesAtlas,
      _locale,
      _settings,
      animationAtlas: await images.load('sprites/animation.webp'),
    );

    await _viewModel.initNewGame(
      tileMap: _mapComponent.tileMap,
      selectedNation: _selectedNation!,
      mapFileName: _mapFileName,
    );

    final stubInput = StubGameFieldViewModelInput();
    _gameGesturesComposer.init(stubInput);
    _gameObjectsComposer.init(_viewModel.gameField, stubInput);

    _viewModel.fireInitializationEvents();

    overlays.add(TutorialGameFieldControls.overlayKey);
  }

  @override
  void onDispose() {
    _updateGameObjectsSubscription?.cancel();
    _gameFieldStateSubscription?.cancel();
    _viewModel.dispose();
    super.onDispose();
  }

  @override
  void onPhoneBackAction() => _viewModel.onPhoneBackAction();

  Future<void> _onUpdateGameEvent(Iterable<UpdateGameEvent> events) async {
    for (var event in events) {
      await _gameObjectsComposer.onUpdateGameEvent(event);
      await _gameGesturesComposer.onUpdateGameEvent(event);
    }
  }

  Future<void> _onGameFieldStateChange(GameFieldState state) async {
    if (state is Completed) {
      gameRef.buildContext?.let(
        (context) => Navigator.of(context).pushNamedAndRemoveUntil(
          Routes.cover,
          (r) => false,
        ),
      );
    }
  }

  @override
  void onCancelled() {
    // not implemented for the tutorial
  }

  @override
  void onCardSelected(GameFieldControlsCard? card) {
    // not implemented for the tutorial
  }

  @override
  void onCardsButtonClick() {
    // not implemented for the tutorial
  }

  @override
  void onCardsPlacingCancelled() {
    // not implemented for the tutorial
  }

  @override
  void onDisbandUnitButtonClick() {
    // not implemented for the tutorial
  }

  @override
  void onEndOfTurnButtonClick() {
    // not implemented for the tutorial
  }

  @override
  void onMenuButtonClick() {
    // not implemented for the tutorial
  }

  @override
  void onMenuObjectivesButtonClick() {
    // not implemented for the tutorial
  }

  @override
  void onMenuQuitButtonClick() {
    // not implemented for the tutorial
  }

  @override
  void onMenuSaveButtonClick() {
    // not implemented for the tutorial
  }

  @override
  void onMenuSettingsButtonClick() {
    // not implemented for the tutorial
  }

  @override
  void onPopupDialogClosed({required bool fireCallbackForAi}) {
    // not implemented for the tutorial
  }

  @override
  void onResortUnits(int cellId, Iterable<String> unitsId, {required bool isCarrier}) {
    // not implemented for the tutorial
  }

  @override
  void onSaveSlotSelected(GameSlot slot) {
    // not implemented for the tutorial
  }

  @override
  void onSettingsClosed(SettingsResult result) {
    // not implemented for the tutorial
  }

  @override
  void onUserConfirmed() {
    // not implemented for the tutorial
  }

  @override
  void onUserDeclined() {
    // not implemented for the tutorial
  }
}
