import 'package:flame_tiled/flame_tiled.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/game_field/game_field_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/player/player_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/game_field_model.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/update_game_event.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/game_field_controls/game_field_controls_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/game_field_state.dart';
import 'package:trench_warfare/shared/architecture/view_model_base.dart';

abstract interface class GameFieldViewModelInput {
  PlayerInput? get input;

  PlayerGameObjectCallback get gameObjectCallback;
}

class GameFieldViewModel extends ViewModelBase implements GameFieldViewModelInput {
  Stream<GameFieldControlsState> get controlsState => _model.controlsState;

  Stream<Iterable<UpdateGameEvent>> get updateGameObjectsEvent => _model.updateGameObjectsEvent;

  Stream<GameFieldState> get gameFieldState => _model.gameFieldState;

  late final GameFieldModel _model;

  @override
  PlayerInput get input => _model.uiInput;

  @override
  PlayerGameObjectCallback get gameObjectCallback => _model.gameObjectCallback;

  GameFieldRead get gameField => _model.gameField;

  GameFieldViewModel() {
    _model = GameFieldModel();
  }

  Future<void> init(RenderableTiledMap tileMap) async {
    await _model.init(tileMap);
  }

  @override
  void dispose() {
    // _audioController.stopSound();

    _model.dispose();
  }
}
