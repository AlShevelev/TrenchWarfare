import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:trench_warfare/core_entities/entities/game_field.dart';
import 'package:trench_warfare/screens/game_field_screen/model/game_field_model.dart';
import 'package:trench_warfare/screens/game_field_screen/model/update_game_event.dart';
import 'package:trench_warfare/screens/game_field_screen/view_model/game_field_controls_state.dart';
import 'package:trench_warfare/screens/game_field_screen/view_model/game_field_state.dart';
import 'package:trench_warfare/shared/architecture/stream/streams_library.dart';
import 'package:trench_warfare/shared/architecture/view_model_base.dart';

class GameFieldViewModel extends ViewModelBase {
  final SingleStream<GameFieldState> _state = SingleStream<GameFieldState>();
  Stream<GameFieldState> get state => _state.output;

  final SingleStream<GameFieldControlsState> _controlsState = SingleStream<GameFieldControlsState>();
  Stream<GameFieldControlsState> get controlsState => _controlsState.output;

  Stream<Iterable<UpdateGameEvent>> get updateGameObjectsEvent => _model.updateGameObjectsEvent;

  late final GameFieldModel _model;

  GameFieldRead get gameField => _model.gameField;

  GameFieldViewModel() {
    _model = GameFieldModel();

    _state.update(Loading());
    _controlsState.update(Invisible());
  }

  Future<void> init(RenderableTiledMap tileMap) async {
    await _model.init(tileMap);

    _state.update(Playing());
    _controlsState.update(Visible(money: _model.money, industryPoints: _model.industryPoints));
  }

  void onClick(Vector2 position) => _model.onClick(position);

  void onLongClickStart(Vector2 position) { }

  void onLongClickEnd() { }

  void onMovementComplete() => _model.onMovementComplete();

  @override
  void dispose() {
    // _audioController.stopSound();
    _state.close();
    _controlsState.close();

    _model.dispose();
  }
}