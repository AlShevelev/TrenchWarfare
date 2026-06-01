import 'package:flame_tiled/flame_tiled.dart';
import 'package:trench_warfare/core/entities/game_field/game_field_library.dart';
import 'package:trench_warfare/core/entities/money/money_unit.dart';
import 'package:trench_warfare/core/enums/nation.dart';
import 'package:trench_warfare/screens/game_field_screen/model/data/game_builders/game_builders_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/game_field_controls/game_field_controls_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/game_field_state.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/update_game_event.dart';
import 'package:trench_warfare/shared/architecture/stream/streams_library.dart';
import 'package:trench_warfare/shared/architecture/view_model_base.dart';

class TutorialGameFieldViewModel extends ViewModelBase {
  final SingleStream<Iterable<UpdateGameEvent>> _updateGameObjectsEvent =
      SingleStream<Iterable<UpdateGameEvent>>();

  Stream<Iterable<UpdateGameEvent>> get updateGameObjectsEvent => _updateGameObjectsEvent.output;

  final SingleStream<GameFieldControlsState> _controlsState = SingleStream<GameFieldControlsState>();

  Stream<GameFieldControlsState> get controlsState => _controlsState.output;

  final SingleStream<GameFieldControlsState> _aiProgressState = SingleStream<GameFieldControlsState>();

  Stream<GameFieldControlsState> get aiProgressState => _aiProgressState.output;

  final SingleStream<GameFieldState> _gameFieldState = SingleStream<GameFieldState>();

  Stream<GameFieldState> get gameFieldState => _gameFieldState.output;

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
    _controlsState.close();
    _aiProgressState.close();
    _gameFieldState.close();
  }

  void fireInitializationEvents() {
    _gameFieldState.update(Loading());

    _createInitialGameObjects();
    _createInitialUi();
    _createFakeAiState();

    _gameFieldState.update(Playing());

    //_moveToCell(10, 10);  // Bases on the scenario stem
  }

  void onPhoneBackAction() => _complete();

  void _createInitialGameObjects() {
    final events = _builtGame.gameField.cells.map((c) => UpdateCell(c, updateBorderCells: []));
    _updateGameObjectsEvent.update(events);
  }

  void _createInitialUi() {
    final state = MainControls(
      totalSum: MoneyUnit(currency: 1000, industryPoints: 1000),
      cellInfo: null,
      armyInfo: null,
      carrierInfo: null,
      nation: Nation.greatBritain,
      showDismissButton: true,
    );
    _controlsState.update(state);
  }

  void _createFakeAiState() => _aiProgressState.update(AiTurnProgress(moneySpending: 0, unitMovement: 0));

  void _moveToCell(int row, int col) {
    final cell = gameField.getCell(row, col);
    _updateGameObjectsEvent.update([MoveCameraToCell(cell)]);
  }

  void _complete() {
    if (_gameFieldState.current is Playing) {
      _gameFieldState.update(Completed());
    }
  }
}
