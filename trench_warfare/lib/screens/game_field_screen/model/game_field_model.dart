import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/foundation.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/day/day_storage.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/game_field/game_field_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/data/readers/game_field/game_field_reader.dart';
import 'package:trench_warfare/screens/game_field_screen/model/data/readers/metadata/metadata_reader.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/player/ai/passive/passive_player_ai.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/player/ai/peaceful/peaceful_player_ai_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/player/ai/player_ai.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/player/player_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/victory/game_over_conditions_calculator.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/game_field_state.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/update_game_event.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/game_field_controls/game_field_controls_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/game_field_storage/game_field_settings_storage.dart';
import 'package:trench_warfare/shared/architecture/disposable.dart';
import 'package:trench_warfare/shared/architecture/stream/streams_library.dart';
import 'package:tuple/tuple.dart';

abstract interface class GameFieldModelCallback {
  void onTurnCompleted();

  void onGameIsOver();
}

class GameFieldModel implements GameFieldModelCallback, Disposable {
  static const _humanIndex = 0;

  int _currentPlayerIndex = _humanIndex;

  final List<PlayerCore> _players = [];

  final List<PlayerAi?> _playersAi = [];

  bool get _isHumanPlayer => _playersAi[_currentPlayerIndex] == null;

  PlayerInput? get input => _isHumanPlayer ? _players[_currentPlayerIndex] : null;

  PlayerGameObjectCallback get gameObjectCallback => _players[_currentPlayerIndex];

  late final GameFieldRead _gameField;
  GameFieldRead get gameField => _gameField;

  final SingleStream<Iterable<UpdateGameEvent>> _updateGameObjectsEvent =
      SingleStream<Iterable<UpdateGameEvent>>();
  Stream<Iterable<UpdateGameEvent>> get updateGameObjectsEvent => _updateGameObjectsEvent.output;

  final SingleStream<GameFieldControlsState> _controlsState = SingleStream<GameFieldControlsState>();
  Stream<GameFieldControlsState> get controlsState =>
      _controlsState.output.map((event) => _isHumanPlayer ? event : Invisible());

  final SingleStream<GameFieldState> _gameFieldState = SingleStream<GameFieldState>();
  Stream<GameFieldState> get gameFieldState => _gameFieldState.output;

  GameFieldModel() {
    _gameFieldState.update(Loading());
  }

  Future<void> init(RenderableTiledMap tileMap) async {
    final metadata = await compute(MetadataReader.read, tileMap.map);

    _gameField = await compute(
      GameFieldReader.read,
      Tuple2<Vector2, TiledMap>(tileMap.destTileSize, tileMap.map),
    );

    final gameFieldSettingsStorage = GameFieldSettingsStorage();

    final gameOverConditionsCalculator = GameOverConditionsCalculator(
      gameField: _gameField,
      metadata: metadata,
    );

    for (var i = 0; i < metadata.nations.length; i++) {
      final dayStorage = DayStorage(0);

      final core = PlayerCore(
        _gameField,
        gameFieldSettingsStorage,
        metadata.nations[i],
        metadata,
        _updateGameObjectsEvent,
        _controlsState,
        this,
        dayStorage,
        gameOverConditionsCalculator,
        isAI: i != _humanIndex,
      );

      _players.add(core);

      // The new map
/*
      switch (i) {
        case 0:
          _playersAi.add(null); // Germany
        case 1:
          _playersAi.add(AggressivePlayerAi(    // Russia
            _gameField,
            core,
            metadata.nations[i].code,
            core.money,
            metadata,
          )); // Greece
        default:
          _playersAi.add(PassivePlayerAi(core));
      }
*/

      // The old map
      switch (i) {
        case _humanIndex:
          _playersAi.add(null); // Austria-Hungary
        case 1:
          _playersAi.add(PeacefulPlayerAi(
            _gameField,
            core,
            metadata.nations[i].code,
            core.money,
            metadata,
            gameOverConditionsCalculator,
          )); // France
        default:
          _playersAi.add(PassivePlayerAi(core)); // Greece & Belgium
      }
    }

    _players[_currentPlayerIndex].onStartTurn();

    _gameFieldState.update(Playing());
  }

  @override
  void onTurnCompleted() {
    _currentPlayerIndex++;
    if (_currentPlayerIndex == _players.length) {
      _currentPlayerIndex = 0;
    }

    _players[_currentPlayerIndex].onStartTurn();

    if (_currentPlayerIndex != _humanIndex) {
      _players[_currentPlayerIndex].onStarTurnConfirmed();
    }
    _playersAi[_currentPlayerIndex]?.start();
  }

  @override
  void dispose() {
    _updateGameObjectsEvent.close();
    _controlsState.close();
    _gameFieldState.close();
  }

  @override
  void onGameIsOver() {
    _gameFieldState.update(Completed());
  }
}
