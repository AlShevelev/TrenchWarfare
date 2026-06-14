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

  int _tutorialStep = 1;

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

    _moveToCell(18, 9);
  }

  void onPhoneBackAction() => _complete();

  void onTap() {
    _tutorialStep++;

    switch (_tutorialStep) {
      case 2:
        {
          _controlsState.update((_controlsState.current as MainControls).setTutorialInfo(
            GameFieldTutorialInfo(
              border: GameFieldControlType.generalPanel,
              panelOnTop: false,
              textLocaleCode: 'tutorial_step_2',
            ),
          ));
        }
      case 3:
        {
          _controlsState.update((_controlsState.current as MainControls).setTutorialInfo(
            GameFieldTutorialInfo(
              border: GameFieldControlType.generalPanel,
              panelOnTop: false,
              textLocaleCode: 'tutorial_step_3',
            ),
          ));
        }
      case 4:
        {
          _moveToCell(2, 2);
          _controlsState.update((_controlsState.current as MainControls).setTutorialInfo(
            GameFieldTutorialInfo(
              border: GameFieldControlType.generalPanel,
              panelOnTop: false,
              textLocaleCode: 'tutorial_step_4',
            ),
          ));
        }
      case 5:
        {
          _moveToCell(8, 2);
          _controlsState.update((_controlsState.current as MainControls).setTutorialInfo(
            GameFieldTutorialInfo(
              border: GameFieldControlType.generalPanel,
              panelOnTop: false,
              textLocaleCode: 'tutorial_step_5',
            ),
          ));
        }
      case 6:
        {
          _moveToCell(14, 1);
          _controlsState.update((_controlsState.current as MainControls).setTutorialInfo(
            GameFieldTutorialInfo(
              border: GameFieldControlType.generalPanel,
              panelOnTop: false,
              textLocaleCode: 'tutorial_step_6',
            ),
          ));
        }
      case 7:
        {
          _controlsState.update((_controlsState.current as MainControls).setTutorialInfo(
            GameFieldTutorialInfo(
              border: GameFieldControlType.generalPanel,
              panelOnTop: false,
              textLocaleCode: 'tutorial_step_7',
            ),
          ));
        }
      case 8:
        {
          _controlsState.update((_controlsState.current as MainControls).setTutorialInfo(
            GameFieldTutorialInfo(
              border: GameFieldControlType.generalPanel,
              panelOnTop: false,
              textLocaleCode: 'tutorial_step_8',
            ),
          ));
        }
      case 9:
        {
          _controlsState.update((_controlsState.current as MainControls).setTutorialInfo(
            GameFieldTutorialInfo(
              border: GameFieldControlType.nextTurn,
              panelOnTop: true,
              textLocaleCode: 'tutorial_step_9',
            ),
          ));
        }
      case 10:
        {
          _controlsState.update((_controlsState.current as MainControls).setTutorialInfo(
            GameFieldTutorialInfo(
              border: GameFieldControlType.dismissUnit,
              panelOnTop: true,
              textLocaleCode: 'tutorial_step_10',
            ),
          ));
        }
      case 11:
        {
          _controlsState.update((_controlsState.current as MainControls).setTutorialInfo(
            GameFieldTutorialInfo(
              border: GameFieldControlType.cards,
              panelOnTop: true,
              textLocaleCode: 'tutorial_step_11',
            ),
          ));
        }
      case 12:
        {
          _moveToCell(4, 13);

          final cell = gameField.getCell(4, 13);

          _controlsState.update(MainControls(
            totalSum: MoneyUnit(currency: 1000, industryPoints: 1000),
            cellInfo: GameFieldControlsCellInfo(
              income: MoneyUnit(currency: 0, industryPoints: 0),
              terrain: cell.terrain,
              terrainModifier: cell.terrainModifier?.type,
              productionCenter: cell.productionCenter,
              nation: cell.nation,
              units: cell.units.toList(growable: true),
            ),
            armyInfo: null,
            carrierInfo: null,
            nation: Nation.greatBritain,
            showDismissButton: true,
            tutorialInfo: GameFieldTutorialInfo(
              border: null,
              panelOnTop: false,
              textLocaleCode: 'tutorial_step_12',
            ),
          ));
        }
      case 13:
        {
          _moveToCell(4, 19);

          final cell = gameField.getCell(4, 19);

          _controlsState.update(MainControls(
            totalSum: MoneyUnit(currency: 1000, industryPoints: 1000),
            cellInfo: null,
            armyInfo: GameFieldControlsArmyInfo(
              cellId: cell.id,
              nation: cell.nation!,
              units: cell.units.toList(growable: true),
            ),
            carrierInfo: null,
            nation: Nation.greatBritain,
            showDismissButton: true,
            tutorialInfo: GameFieldTutorialInfo(
              border: null,
              panelOnTop: true,
              textLocaleCode: 'tutorial_step_13',
            ),
          ));
        }
      case 14:
        {
          _controlsState.update((_controlsState.current as MainControls).setTutorialInfo(
            GameFieldTutorialInfo(
              border: null,
              panelOnTop: true,
              textLocaleCode: 'tutorial_step_14',
            ),
          ));
        }
      case 15:
        {
          _moveToCell(4, 8);

          _controlsState.update(MainControls(
            totalSum: MoneyUnit(currency: 1000, industryPoints: 1000),
            cellInfo: null,
            armyInfo: null,
            carrierInfo: null,
            nation: Nation.greatBritain,
            showDismissButton: true,
            tutorialInfo: GameFieldTutorialInfo(
              border: null,
              panelOnTop: false,
              textLocaleCode: 'tutorial_step_15',
            ),
          ));
        }
      case 16:
        {
          _controlsState.update((_controlsState.current as MainControls).setTutorialInfo(
            GameFieldTutorialInfo(
              border: null,
              panelOnTop: false,
              textLocaleCode: 'tutorial_step_16',
            ),
          ));
        }
      case 17:
        {
          _controlsState.update((_controlsState.current as MainControls).setTutorialInfo(
            GameFieldTutorialInfo(
              border: null,
              panelOnTop: false,
              textLocaleCode: 'tutorial_step_17',
            ),
          ));
        }
      case 18:
        {
          _controlsState.update((_controlsState.current as MainControls).setTutorialInfo(
            GameFieldTutorialInfo(
              border: null,
              panelOnTop: false,
              textLocaleCode: 'tutorial_step_18',
            ),
          ));
        }
      case 19:
        {
          _moveToCell(19, 16);

          _controlsState.update((_controlsState.current as MainControls).setTutorialInfo(
            GameFieldTutorialInfo(
              border: null,
              panelOnTop: false,
              textLocaleCode: 'tutorial_step_19',
            ),
          ));
        }
      case 20:
        {
          _moveToCell(26, 2);

          _controlsState.update((_controlsState.current as MainControls).setTutorialInfo(
            GameFieldTutorialInfo(
              border: null,
              panelOnTop: false,
              textLocaleCode: 'tutorial_step_20',
            ),
          ));
        }
      case 21:
        {
          _controlsState.update((_controlsState.current as MainControls).setTutorialInfo(
            GameFieldTutorialInfo(
              border: null,
              panelOnTop: false,
              textLocaleCode: 'tutorial_step_21',
            ),
          ));
        }
      case 22:
        {
          _controlsState.update((_controlsState.current as MainControls).setTutorialInfo(
            GameFieldTutorialInfo(
              border: null,
              panelOnTop: false,
              textLocaleCode: 'tutorial_step_22',
            ),
          ));
        }
      case 23:
        {
          _moveToCell(9, 7);

          _controlsState.update((_controlsState.current as MainControls).setTutorialInfo(
            GameFieldTutorialInfo(
              border: null,
              panelOnTop: false,
              textLocaleCode: 'tutorial_step_23',
            ),
          ));
        }
      case 24:
        {
          _moveToCell(9, 9);

          _controlsState.update((_controlsState.current as MainControls).setTutorialInfo(
            GameFieldTutorialInfo(
              border: null,
              panelOnTop: false,
              textLocaleCode: 'tutorial_step_24',
            ),
          ));
        }
      case 25:
        {
          _moveToCell(8, 26);

          _controlsState.update((_controlsState.current as MainControls).setTutorialInfo(
            GameFieldTutorialInfo(
              border: null,
              panelOnTop: false,
              textLocaleCode: 'tutorial_step_25',
            ),
          ));
        }
      case 26:
        {
          _controlsState.update((_controlsState.current as MainControls).setTutorialInfo(
            GameFieldTutorialInfo(
              border: null,
              panelOnTop: false,
              textLocaleCode: 'tutorial_step_26',
            ),
          ));
        }
      case 27:
        {
          _moveToCell(10, 16);
          _controlsState.update((_controlsState.current as MainControls).setTutorialInfo(
            GameFieldTutorialInfo(
              border: null,
              panelOnTop: false,
              textLocaleCode: 'tutorial_step_27',
            ),
          ));
        }
      case 28:
        {
          _controlsState.update((_controlsState.current as MainControls).setTutorialInfo(
            GameFieldTutorialInfo(
              border: null,
              panelOnTop: false,
              textLocaleCode: 'tutorial_step_28',
            ),
          ));
        }
      case 29:
        {
          _controlsState.update((_controlsState.current as MainControls).setTutorialInfo(
            GameFieldTutorialInfo(
              border: null,
              panelOnTop: false,
              textLocaleCode: 'tutorial_step_29',
            ),
          ));
        }
      case 30:
        {
          _moveToCell(17, 24);
          _controlsState.update((_controlsState.current as MainControls).setTutorialInfo(
            GameFieldTutorialInfo(
              border: null,
              panelOnTop: false,
              textLocaleCode: 'tutorial_step_30',
            ),
          ));
        }
      case 31:
        {
          _controlsState.update((_controlsState.current as MainControls).setTutorialInfo(
            GameFieldTutorialInfo(
              border: null,
              panelOnTop: false,
              textLocaleCode: 'tutorial_step_31',
            ),
          ));
        }
      case 32:
        {
          _controlsState.update((_controlsState.current as MainControls).setTutorialInfo(
            GameFieldTutorialInfo(
              border: null,
              panelOnTop: false,
              textLocaleCode: 'tutorial_step_32',
            ),
          ));
        }
      case 33:
        {
          _complete();
        }
    }
  }

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
      tutorialInfo: GameFieldTutorialInfo(
        border: null,
        panelOnTop: false,
        textLocaleCode: 'tutorial_step_1',
      ),
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
