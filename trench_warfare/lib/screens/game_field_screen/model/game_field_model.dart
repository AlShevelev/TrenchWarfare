import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/foundation.dart';
import 'package:trench_warfare/core_entities/entities/game_field.dart';
import 'package:trench_warfare/screens/game_field_screen/model/data/readers/game_field/game_field_reader.dart';
import 'package:trench_warfare/screens/game_field_screen/model/data/readers/metadata/dto/map_metadata.dart';
import 'package:trench_warfare/screens/game_field_screen/model/data/readers/metadata/metadata_reader.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/player/ai/player_ai_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/player/player_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/update_game_event.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/game_field_controls/game_field_controls_library.dart';
import 'package:trench_warfare/shared/architecture/disposable.dart';
import 'package:trench_warfare/shared/architecture/stream/streams_library.dart';
import 'package:tuple/tuple.dart';

abstract interface class GameFieldModelCallback {
  void onTurnCompleted();
}

class GameFieldModel implements GameFieldModelCallback, Disposable {
  static const _startIndex = 0;

  int _currentPlayerIndex = _startIndex;

  final List<PlayerCore> _players = [];

  final List<PlayerAi?> _playersAi = [];

  PlayerInput get input => _players[_currentPlayerIndex];

  late final MapMetadata _metadata;

  late final GameFieldRead _gameField;
  GameFieldRead get gameField => _gameField;

  final SingleStream<Iterable<UpdateGameEvent>> _updateGameObjectsEvent =
      SingleStream<Iterable<UpdateGameEvent>>();
  Stream<Iterable<UpdateGameEvent>> get updateGameObjectsEvent => _updateGameObjectsEvent.output;

  final SingleStream<GameFieldControlsState> _controlsState = SingleStream<GameFieldControlsState>();
  Stream<GameFieldControlsState> get controlsState => _controlsState.output;

  Future<void> init(RenderableTiledMap tileMap) async {
    _metadata = await compute(MetadataReader.read, tileMap.map);
    _gameField = await compute(
      GameFieldReader.read,
      Tuple2<Vector2, TiledMap>(tileMap.destTileSize, tileMap.map),
    );

    for (var i = 0; i < _metadata.nations.length; i++) {
      final core = PlayerCore(
        _gameField,
        _metadata.nations[i],
        _metadata,
        _updateGameObjectsEvent,
        _controlsState,
        this,
      );

      _players.add(core);

      _playersAi.add(i == _startIndex ? null : PassivePlayerAi(core));

      core.init(updateGameField: i == _startIndex);
    }

    _players[_startIndex].setInputBlock(blocked: false);
  }

  @override
  void onTurnCompleted() {
    _players[_currentPlayerIndex].setInputBlock(blocked: true);

    _currentPlayerIndex++;
    if (_currentPlayerIndex == _players.length) {
      _currentPlayerIndex = 0;
    }

    _players[_currentPlayerIndex].setInputBlock(blocked: false);
    _players[_currentPlayerIndex].onStartTurn();

    _playersAi[_currentPlayerIndex]?.start();
  }

  @override
  void dispose() {
    _updateGameObjectsEvent.close();
    _controlsState.close();
  }
}
