import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_gdx_texture_packer/atlas/texture_atlas.dart';
import 'package:flame_gdx_texture_packer/flame_gdx_texture_packer.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:trench_warfare/core/enums/nation.dart';
import 'package:trench_warfare/core/localization/app_locale.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/update_game_event.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/composers/game_objects/game_objects_composer.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/composers/gestures/game_gestures_composer_library.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/composers/gestures/zoom_constants.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/game_object_components/game_field_components_library.dart';
import 'package:trench_warfare/screens/tutorials/ui/settings_storage_read_stub_impl.dart';
import 'package:trench_warfare/screens/tutorials/view_model/stub_game_field_view_model_input.dart';
import 'package:trench_warfare/screens/tutorials/view_model/tutorial_game_field_view_model.dart';
import 'package:trench_warfare/shared/data/settings/settings_storage_read.dart';

// abstract interface class TutorialGameFieldForControls {
//   Stream<TutorialGameFieldControlsState> get controlsState;
//
//   TextureAtlas get spritesAtlas;
//
//   void onPhoneBackAction();
// }

class TutorialGameField extends FlameGame {
  late final TutorialGameFieldViewModel _viewModel;

  late TiledComponent _mapComponent;

  late final String _mapFileName;

  late final Nation? _selectedNation;

  final AppLocale _locale;

  late final SettingsStorageRead _settings;

  StreamSubscription? _updateGameObjectsSubscription;

  late final TextureAtlas _spritesAtlas;

  late final GameObjectsComposer _gameObjectsComposer;
  late final GameGesturesComposer _gameGesturesComposer;

  TutorialGameField({
    required String mapFileName,
    Nation? selectedNation,
    required AppLocale locale,
  })
      : _mapFileName = mapFileName,
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
      ..zoom = ZoomConstants.startZoom
      ..anchor = Anchor.center;

    _mapComponent = await TiledComponent.load(
      _mapFileName.replaceFirst('assets/tiles/', ''),
      ComponentConstants.cellRealSize,
    );
    world.add(_mapComponent);

    _updateGameObjectsSubscription = _viewModel.updateGameObjectsEvent.listen(_onUpdateGameEvent);

    _gameGesturesComposer = GameGesturesComposer(
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
  }

  @override
  void onDispose() {
    _updateGameObjectsSubscription?.cancel();
    _viewModel.dispose();
    super.onDispose();
  }

  Future<void> _onUpdateGameEvent(Iterable<UpdateGameEvent> events) async {
    for (var event in events) {
      await _gameObjectsComposer.onUpdateGameEvent(event);
      await _gameGesturesComposer.onUpdateGameEvent(event);
    }
  }
}
