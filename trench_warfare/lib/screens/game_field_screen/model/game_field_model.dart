import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/foundation.dart';
import 'package:trench_warfare/core/entities/map_metadata/map_metadata_record.dart';
import 'package:trench_warfare/core/enums/aggressiveness.dart';
import 'package:trench_warfare/core/enums/nation.dart';
import 'package:trench_warfare/screens/game_field_screen/model/data/readers/metadata/dto/map_metadata.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/day/day_storage.dart';
import 'package:trench_warfare/core/entities/game_field/game_field_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/data/readers/game_field/game_field_reader.dart';
import 'package:trench_warfare/screens/game_field_screen/model/data/readers/metadata/metadata_reader.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/player/ai/aggressive/aggressive_player_ai_library.dart';
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
import 'package:trench_warfare/shared/logger/logger_library.dart';
import 'package:tuple/tuple.dart';

abstract interface class GameFieldModelCallback {
  void onTurnCompleted();

  void onGameIsOver();
}

class GameFieldModel implements GameFieldModelCallback, Disposable {
  static const _humanIndex = 0;

  int _currentPlayerIndex = _humanIndex;

  final List<PlayerInputProxy> _players = [];

  final List<PlayerAi?> _playersAi = [];

  bool get isHumanPlayer => _playersAi[_currentPlayerIndex] == null;

  PlayerInput get uiInput => _players[_currentPlayerIndex];

  PlayerGameObjectCallback get gameObjectCallback => _players[_currentPlayerIndex];

  late final GameFieldRead _gameField;
  GameFieldRead get gameField => _gameField;

  final SingleStream<Iterable<UpdateGameEvent>> _updateGameObjectsEvent =
      SingleStream<Iterable<UpdateGameEvent>>();
  Stream<Iterable<UpdateGameEvent>> get updateGameObjectsEvent => _updateGameObjectsEvent.output;

  final SingleStream<GameFieldControlsState> _controlsState = SingleStream<GameFieldControlsState>();
  Stream<GameFieldControlsState> get controlsState =>
      _controlsState.output.map((event) => isHumanPlayer || event is DefeatControls ? event : Invisible());

  final SingleStream<GameFieldState> _gameFieldState = SingleStream<GameFieldState>();
  Stream<GameFieldState> get gameFieldState => _gameFieldState.output;

  GameFieldModel() {
    _gameFieldState.update(Loading());
  }

  Future<void> init(RenderableTiledMap tileMap, Nation selectedNation) async {
    Logger.info('initialization', tag: 'GAME_GENERAL');

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

    final players = _sortPlayers(metadata.nations, selectedNation);
    for (var i = 0; i < players.length; i++) {
      _createPlayer(
        index: i,
        gameFieldSettingsStorage: gameFieldSettingsStorage,
        gameOverConditionsCalculator: gameOverConditionsCalculator,
        metadata: metadata,
        nationRecord: players[i],
      );
    }

    Logger.info('initialization completed', tag: 'GAME_GENERAL');

    Logger.info(
      'new turn is started for player $_currentPlayerIndex (isHuman = $isHumanPlayer)',
      tag: 'GAME_GENERAL',
    );
    _players[_currentPlayerIndex].onStartTurn();

    _gameFieldState.update(Playing());
  }

  @override
  void onTurnCompleted() {
    _currentPlayerIndex++;
    if (_currentPlayerIndex == _players.length) {
      _currentPlayerIndex = 0;
    }

    Logger.info(
      'new turn is started for player $_currentPlayerIndex (isHuman = $isHumanPlayer)',
      tag: 'GAME_GENERAL',
    );
    _players[_currentPlayerIndex].onStartTurn();

    if (_currentPlayerIndex != _humanIndex) {
      _players[_currentPlayerIndex].onPopupDialogClosed();
    }
    _playersAi[_currentPlayerIndex]?.start();
  }

  @override
  void dispose() {
    Logger.info('disposed', tag: 'GAME_GENERAL');

    _updateGameObjectsEvent.close();
    _controlsState.close();
    _gameFieldState.close();
  }

  @override
  void onGameIsOver() {
    Logger.info('the game is over', tag: 'GAME_GENERAL');

    _gameFieldState.update(Completed());
  }

  List<NationRecord> _sortPlayers(Iterable<NationRecord> players, Nation selectedNation) {
    final result = <NationRecord>[...players];

    final firstAggressive = result
        .indexWhere((it) => it.aggressiveness == Aggressiveness.aggressive && it.code == selectedNation);

    if (firstAggressive != _humanIndex) {
      result.insert(_humanIndex, result.removeAt(firstAggressive));
    }

    return result;
  }

  void _createPlayer({
    required int index,
    required GameFieldSettingsStorage gameFieldSettingsStorage,
    required GameOverConditionsCalculator gameOverConditionsCalculator,
    required MapMetadata metadata,
    required NationRecord nationRecord,
  }) {
    final isHuman = index == _humanIndex;

    final dayStorage = DayStorage(0);

    final core = PlayerCore(
      _gameField,
      gameFieldSettingsStorage,
      nationRecord,
      metadata,
      _updateGameObjectsEvent,
      _controlsState,
      this,
      dayStorage,
      gameOverConditionsCalculator,
      isAI: !isHuman,
    );

    _players.add(isHuman ? core : PlayerAiInputProxy(playerCore: core));

    if (isHuman) {
      _playersAi.add(null);
    } else {
      final ai = switch (nationRecord.aggressiveness) {
        Aggressiveness.passive => PassivePlayerAi(core),
        Aggressiveness.peaceful => PeacefulPlayerAi(
            _gameField,
            core,
            nationRecord.code,
            core.money,
            metadata,
            gameOverConditionsCalculator,
          ),
        Aggressiveness.aggressive => AggressivePlayerAi(
            gameField,
            core,
            nationRecord.code,
            core.money,
            metadata,
            gameOverConditionsCalculator,
          )
      };

      _playersAi.add(ai);
    }

    Logger.info(
      'a player is created. index: $index; isHuman: $isHuman; nation: ${nationRecord.code}; '
      'startCurrency: ${nationRecord.startMoney}; startIndustryPoints: ${nationRecord.startIndustryPoints}',
      tag: 'GAME_GENERAL',
    );
  }
}
