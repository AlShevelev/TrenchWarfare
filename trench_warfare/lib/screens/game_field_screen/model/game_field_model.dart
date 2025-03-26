import 'package:trench_warfare/core/entities/map_metadata/map_metadata_record.dart';
import 'package:trench_warfare/core/enums/aggressiveness.dart';
import 'package:trench_warfare/core/enums/game_slot.dart';
import 'package:trench_warfare/core/enums/nation.dart';
import 'package:trench_warfare/screens/game_field_screen/model/data/game_builders/game_builders_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/data/readers/metadata/dto/map_metadata.dart';
import 'package:trench_warfare/screens/game_field_screen/model/data/save_game/game_saver.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/animation_time/animation_time_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/day/day_storage.dart';
import 'package:trench_warfare/core/entities/game_field/game_field_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/money/money_storage.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/movement/movement_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/player/ai/aggressive/aggressive_player_ai_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/player/ai/aggressive/phases/carriers/carriers_phase_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/player/ai/passive/passive_player_ai.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/player/ai/peaceful/peaceful_player_ai_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/player/ai/player_ai.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/player/player_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/victory/game_over_conditions_calculator.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/game_field_state.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/update_game_event.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/game_field_controls/game_field_controls_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/game_field_storage/game_field_settings_storage.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/game_pause.dart';
import 'package:trench_warfare/shared/architecture/disposable.dart';
import 'package:trench_warfare/shared/architecture/stream/streams_library.dart';
import 'package:trench_warfare/shared/logger/logger_library.dart';

abstract interface class GameFieldModelCallback {
  void onTurnCompleted();

  void onGameIsOver();

  void saveGame(GameSlot slot);
}

class GameFieldModel implements GameFieldModelCallback, Disposable {
  late final int _humanIndex;

  int _currentPlayerIndex = 0;

  final List<PlayerInputProxy> _players = [];

  final List<PlayerAi?> _playersAi = [];

  bool get isHumanPlayer => _playersAi[_currentPlayerIndex] == null;

  PlayerInput get uiInput => _players[_currentPlayerIndex];

  PlayerGameObjectCallback get gameObjectCallback => _players[_currentPlayerIndex];

  late final GameFieldRead _gameField;

  GameFieldRead get gameField => _gameField;

  late final String _mapFileName;

  final SingleStream<Iterable<UpdateGameEvent>> _updateGameObjectsEvent =
      SingleStream<Iterable<UpdateGameEvent>>();

  Stream<Iterable<UpdateGameEvent>> get updateGameObjectsEvent => _updateGameObjectsEvent.output;

  final SingleStream<GameFieldControlsState> _controlsState = SingleStream<GameFieldControlsState>();

  Stream<GameFieldControlsState> get controlsState => _controlsState.output
      .map((event) => isHumanPlayer || event is DefeatControls || event is WinControls ? event : Invisible());

  final SingleStream<GameFieldControlsState> _aiProgressState = SingleStream<GameFieldControlsState>();

  Stream<GameFieldControlsState> get aiProgressState => _aiProgressState.output;

  final SingleStream<GameFieldState> _gameFieldState = SingleStream<GameFieldState>();

  Stream<GameFieldState> get gameFieldState => _gameFieldState.output;

  late final MapMetadata _metadata;

  late final GameFieldSettingsStorage _settingsStorage;

  late final GameOverConditionsCalculator _gameOverConditionsCalculator;

  late final List<NationRecord> _sortedPlayers;

  late final DayStorage _humanDayStorage;

  final GamePauseWait _gamePauseWait;

  GameFieldModel(GamePauseWait gamePauseWait) : _gamePauseWait = gamePauseWait {
    _gameFieldState.update(Loading());
  }

  Future<void> init({
    required GameBuilder builder,
  }) async {
    Logger.info('initialization', tag: 'GAME_GENERAL');

    final gameBuildResult = await builder.build();

    _mapFileName = gameBuildResult.mapFileName;
    _metadata = gameBuildResult.metadata;
    _gameField = gameBuildResult.gameField;
    _settingsStorage = gameBuildResult.settings;
    _gameOverConditionsCalculator = gameBuildResult.conditions;
    _sortedPlayers = gameBuildResult.playingNations;
    _humanIndex = gameBuildResult.humanIndex;
    _currentPlayerIndex = _humanIndex;

    final animationTimeFacade = AnimationTimeFacade(
      humanUnitsSpeed: gameBuildResult.humanUnitsSpeed,
      aiUnitsSpeed: gameBuildResult.aiUnitsSpeed,
    );

    final movementResultBridge = MovementResultBridgeImpl();

    for (var i = 0; i < _sortedPlayers.length; i++) {
      _createPlayer(
        index: i,
        gameFieldSettingsStorage: _settingsStorage,
        gameOverConditionsCalculator: _gameOverConditionsCalculator,
        metadata: _metadata,
        nationRecord: _sortedPlayers[i],
        humanRecord: _sortedPlayers[_humanIndex],
        startDay: gameBuildResult.nationsDayNumber[i],
        initialTransfers: gameBuildResult.transfers,
        money: gameBuildResult.money,
        isGameLoaded: gameBuildResult.isGameLoaded,
        animationTimeFacade: animationTimeFacade,
        gamePauseWait: _gamePauseWait,
        movementResultBridge: movementResultBridge,
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
    _aiProgressState.close();
    _controlsState.close();
    _gameFieldState.close();
  }

  @override
  void onGameIsOver() {
    _gameFieldState.update(Completed());
  }

  void _createPlayer({
    required int index,
    required GameFieldSettingsStorage gameFieldSettingsStorage,
    required GameOverConditionsCalculator gameOverConditionsCalculator,
    required MapMetadata metadata,
    required NationRecord nationRecord,
    required NationRecord humanRecord,
    required int startDay,
    required Map<Nation, Iterable<TroopTransferReadForSaving>> initialTransfers,
    required Map<Nation, MoneyStorage> money,
    required bool isGameLoaded,
    required AnimationTimeFacade animationTimeFacade,
    required GamePauseWait gamePauseWait,
    required MovementResultBridgeImpl movementResultBridge,
  }) {
    final isHuman = index == _humanIndex;

    final dayStorage = DayStorage(startDay);

    if (isHuman) {
      _humanDayStorage = dayStorage;
    }

    final core = PlayerCore(
      _gameField,
      gameFieldSettingsStorage,
      myNation: nationRecord.code,
      humanNation: humanRecord.code,
      metadata,
      _updateGameObjectsEvent,
      _controlsState,
      this,
      dayStorage,
      gameOverConditionsCalculator,
      money[nationRecord.code]!,
      animationTimeFacade,
      gamePauseWait: isHuman ? null : gamePauseWait,
      // We don't need to pause the app for a human player
      movementResultBridge: isHuman ? null : movementResultBridge,
      isAI: !isHuman,
      isGameLoaded: isGameLoaded,
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
            _aiProgressState,
          ),
        Aggressiveness.aggressive => AggressivePlayerAi(
            gameField,
            core,
            nationRecord.code,
            core.money,
            metadata,
            gameOverConditionsCalculator,
            initialTransfers[nationRecord.code] ?? [],
            _aiProgressState,
            movementResultBridge,
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

  @override
  void saveGame(GameSlot slot) {
    final transfers = <Nation, Iterable<TroopTransferReadForSaving>>{};
    for (final ai in _playersAi) {
      if (ai is! AggressivePlayerAi) {
        continue;
      }

      final playerTransfers = ai.transfersStorage.allTransfers
          .map((t) => t as TroopTransferReadForSaving)
          .toList(growable: false);

      if (playerTransfers.isNotEmpty) {
        transfers[ai.myNation] = playerTransfers;
      }
    }

    final allMoney =
        Map.fromEntries(_players.map((p) => p as PlayerMoney).map((m) => MapEntry(m.nation, m.money)));

    GameSaver.start(
      slot: slot,
      mapFileName: _mapFileName,
      isAutosave: slot == GameSlot.autoSave,
      day: _humanDayStorage.day,
      humanPlayerIndex: _humanIndex,
      gameField: _gameField,
      metadata: _metadata,
      settingsStorage: _settingsStorage,
      defeated: _gameOverConditionsCalculator.defeated,
      playingNations: _sortedPlayers.map((p) => p.code).toList(growable: false),
    ).addTroopTransfers(transfers).addMoney(allMoney).save();
  }
}
