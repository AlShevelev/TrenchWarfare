import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/foundation.dart';
import 'package:trench_warfare/core_entities/entities/game_field.dart';
import 'package:trench_warfare/screens/game_field_screen/model/data/readers/game_field/game_field_reader.dart';
import 'package:trench_warfare/screens/game_field_screen/model/data/readers/metadata/dto/map_metadata.dart';
import 'package:trench_warfare/screens/game_field_screen/model/data/readers/metadata/metadata_reader.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/player/player_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/update_game_event.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/game_field_controls/game_field_controls_library.dart';
import 'package:trench_warfare/shared/architecture/disposable.dart';
import 'package:trench_warfare/shared/architecture/stream/streams_library.dart';
import 'package:tuple/tuple.dart';

class GameFieldModel implements Disposable {
  late final List<PlayerCore> _players;

  PlayerInput get input => _players[_currentPlayerIndex];

  int _currentPlayerIndex = 0;

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

    _players = _metadata.nations
        .map((n) => PlayerCore(_gameField, n, _metadata, _updateGameObjectsEvent, _controlsState))
        .toList(growable: false);

    for (var i = 0 ; i< _players.length; i++) {
      _players[i].init(updateGameField: i == 0);
    }
  }

  @override
  void dispose() {
    _updateGameObjectsEvent.close();
    _controlsState.close();
  }
}
