import 'package:flame_tiled/flame_tiled.dart';
import 'package:trench_warfare/core/entities/game_field/game_field_library.dart';
import 'package:trench_warfare/core/enums/nation.dart';
import 'package:trench_warfare/screens/game_field_screen/model/data/game_builders/game_builders_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/update_game_event.dart';
import 'package:trench_warfare/shared/architecture/stream/streams_library.dart';
import 'package:trench_warfare/shared/architecture/view_model_base.dart';

class TutorialGameFieldViewModel extends ViewModelBase {
  // Stream<TutorialGameFieldControlsState> get controlsState => _model.controlsState;
  //
  // Stream<GameFieldState> get gameFieldState => _model.gameFieldState;

  //late final GameFieldModel _model;

  //GameFieldRead get gameField => _model.gameField;

  final SingleStream<Iterable<UpdateGameEvent>> _updateGameObjectsEvent =
      SingleStream<Iterable<UpdateGameEvent>>();

  Stream<Iterable<UpdateGameEvent>> get updateGameObjectsEvent => _updateGameObjectsEvent.output;

  late final GameBuildResult _builtGame;

  GameFieldRead get gameField => _builtGame.gameField;

  TutorialGameFieldViewModel();

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

    _builtGame = await builder.build();
  }

  @override
  void dispose() {
    _updateGameObjectsEvent.close();
  }

  void fireInitializationEvents() {
    final events = _builtGame.gameField.cells.map((c) => UpdateCell(c, updateBorderCells: []));
    _updateGameObjectsEvent.update(events);
  }
}
