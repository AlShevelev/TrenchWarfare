import 'package:flame_tiled/flame_tiled.dart';
import 'package:trench_warfare/core_entities/entities/game_field.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/player/player_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/game_field_model.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/update_game_event.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/game_field_controls/game_field_controls_library.dart';
import 'package:trench_warfare/screens/game_field_screen/view_model/game_field_state.dart';
import 'package:trench_warfare/shared/architecture/stream/streams_library.dart';
import 'package:trench_warfare/shared/architecture/view_model_base.dart';

abstract interface class GameFieldViewModelInput {
  PlayerInput? get humanInput;

  PlayerGameObjectCallback get gameObjectCallback;
}

class GameFieldViewModel extends ViewModelBase implements GameFieldViewModelInput {
  final SingleStream<GameFieldState> _state = SingleStream<GameFieldState>();
  Stream<GameFieldState> get state => _state.output;

  Stream<GameFieldControlsState> get controlsState => _model.controlsState;

  Stream<Iterable<UpdateGameEvent>> get updateGameObjectsEvent => _model.updateGameObjectsEvent;

  late final GameFieldModel _model;

  @override
  PlayerInput? get humanInput => _model.input;

  @override
  PlayerGameObjectCallback get gameObjectCallback => _model.gameObjectCallback;

  GameFieldRead get gameField => _model.gameField;

  GameFieldViewModel() {
    _model = GameFieldModel();

    _state.update(Loading());
  }

  Future<void> init(RenderableTiledMap tileMap) async {
    await _model.init(tileMap);

    _state.update(Playing());
  }

  @override
  void dispose() {
    // _audioController.stopSound();
    _state.close();

    _model.dispose();
  }
}
