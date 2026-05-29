import 'package:flame_tiled/flame_tiled.dart';
import 'package:trench_warfare/core/enums/nation.dart';
import 'package:trench_warfare/screens/game_field_screen/model/data/game_builders/game_builders_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/game_field_state.dart';
import 'package:trench_warfare/screens/tutorials/model/dto/tutorial_game_field_controls_state.dart';
import 'package:trench_warfare/shared/architecture/view_model_base.dart';

class TutorialGameFieldViewModel extends ViewModelBase {
  // Stream<TutorialGameFieldControlsState> get controlsState => _model.controlsState;
  //
  // Stream<GameFieldState> get gameFieldState => _model.gameFieldState;

  //late final GameFieldModel _model;

  //GameFieldRead get gameField => _model.gameField;

  TutorialGameFieldViewModel() {
    //_model = GameFieldModel(gamePauseWait);
  }

  Future<void> initNewGame({
    required RenderableTiledMap tileMap,
    required Nation selectedNation,
    required String mapFileName,
  }) async {
    final builder = NewGameBuilder(
      mapFileName: mapFileName,
      tileMap: tileMap,
      selectedNation: selectedNation,
    );
//    await _model.init(builder: builder);
  }

  @override
  void dispose() {
    //_model.dispose();
  }
}
