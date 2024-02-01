import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:trench_warfare/screens/game_field_screen/model/game_field_model.dart';
import 'package:trench_warfare/screens/game_field_screen/model/update_game_event.dart';
import 'package:trench_warfare/screens/game_field_screen/view_model/game_field_state.dart';
import 'package:trench_warfare/shared/architecture/simple_stream.dart';
import 'package:trench_warfare/shared/architecture/view_model_base.dart';

class GameFieldViewModel extends ViewModelBase {
  final SimpleStream<GameFieldState> _state = SimpleStream<GameFieldState>();
  Stream<GameFieldState> get state => _state.output;

  Stream<Iterable<UpdateGameEvent>> get updateGameObjectsEvent => _model.updateGameObjectsEvent;

  late final GameFieldModel _model;

  GameFieldViewModel() {
    _model = GameFieldModel();

    _state.update(Loading());
  }

  Future<void> init(RenderableTiledMap tileMap) async {
    await _model.init(tileMap);

    _state.update(Playing());
  }

  void onClick(Vector2 position) => _model.onClick(position);

  void onMovementComplete() => _model.onMovementComplete();

  @override
  void dispose() {
    // _audioController.stopSound();
    _state.close();
    _model.dispose();
  }
}