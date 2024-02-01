import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/foundation.dart';
import 'package:trench_warfare/core_entities/entities/game_field.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/common_algs/find_cell_by_position.dart';
import 'package:trench_warfare/screens/game_field_screen/model/data/readers/game_field/game_field_reader.dart';
import 'package:trench_warfare/screens/game_field_screen/model/data/readers/metadata/dto/map_metadata.dart';
import 'package:trench_warfare/screens/game_field_screen/model/data/readers/metadata/metadata_reader.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/sm/game_field_sm.dart';
import 'package:trench_warfare/screens/game_field_screen/model/update_game_event.dart';
import 'package:trench_warfare/shared/architecture/disposable.dart';
import 'package:tuple/tuple.dart';

class GameFieldModel implements Disposable {
  late final MapMetadata _metadata;
  late final GameFieldReadOnly _gameField;

  late final GameFieldStateMachine _stateMachine = GameFieldStateMachine();

  Stream<Iterable<UpdateGameEvent>> get updateGameObjectsEvent => _stateMachine.updateGameObjectsEvent;

  GameFieldModel();

  Future<void> init(RenderableTiledMap tileMap) async {
    _metadata = await compute(MetadataReader.read, tileMap.map);
    _gameField = await compute(GameFieldReader.read, Tuple2<Vector2, TiledMap>(tileMap.destTileSize, tileMap.map));

    _stateMachine.process(Init(_gameField, _metadata.nations.first.code));
  }

  void onClick(Vector2 position) {
    final clickedCell = FindCellByPosition.find(_gameField, position);
    _stateMachine.process(Click(clickedCell));
  }

  void onMovementComplete() => _stateMachine.process(MovementComplete());

  @override
  void dispose() {
    _stateMachine.dispose();
  }
}