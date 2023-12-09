import 'package:flame_tiled/flame_tiled.dart';
import 'package:trench_warfare/screens/game_field_screen/model/game_field_model.dart';
import 'package:trench_warfare/screens/game_field_screen/view_model/game_field_state.dart';
import 'package:trench_warfare/shared/architecture/simple_stream.dart';
import 'package:trench_warfare/shared/architecture/view_model_base.dart';

class GameFieldViewModel extends ViewModelBase {
  final SimpleStream<GameFieldState> _state = SimpleStream<GameFieldState>();
  Stream<GameFieldState> get state => _state.output;

  final SimpleStream<GameFieldState> _event = SimpleStream<GameFieldState>();
  Stream<GameFieldState> get event => _state.output;

  late final GameFieldModel _model;

  GameFieldViewModel() {
    _state.update(Loading());
  }

  void init(TiledMap map) {
    _model = GameFieldModel();
    _model.init(map);

    _state.update(Playing());
  }

  @override
  void dispose() {
    // _audioController.stopSound();
    _state.close();
    _event.close();
  }
}