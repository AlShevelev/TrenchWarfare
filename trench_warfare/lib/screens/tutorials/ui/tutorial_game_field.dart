import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_gdx_texture_packer/atlas/texture_atlas.dart';
import 'package:flame_gdx_texture_packer/flame_gdx_texture_packer.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:trench_warfare/core/enums/nation.dart';
import 'package:trench_warfare/core/localization/app_locale.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/composers/gestures/game_gestures_composer_library.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/composers/gestures/zoom_constants.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/game_object_components/game_field_components_library.dart';
import 'package:trench_warfare/screens/tutorials/view_model/stub_game_field_view_model_input.dart';
import 'package:trench_warfare/screens/tutorials/view_model/tutorial_game_field_view_model.dart';

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

  late final TextureAtlas _spritesAtlas;

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

    _gameGesturesComposer = GameGesturesComposer(
      mapSize: Offset(_mapComponent.width, _mapComponent.height),
      camera: GesturesCamera(camera),
    );

    _spritesAtlas = await fromAtlas('images/sprites/sprites_atlas');

    await _viewModel.initNewGame(
      tileMap: _mapComponent.tileMap,
      selectedNation: _selectedNation!,
      mapFileName: _mapFileName,
    );

    _gameGesturesComposer.init(StubGameFieldViewModelInput());
  }

  @override
  void onDispose() {
    _viewModel.dispose();
    super.onDispose();
  }
}
