import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/foundation.dart';
import 'package:trench_warfare/core_entities/entities/game_field.dart';
import 'package:trench_warfare/screens/game_field_screen/model/readers/game_field/game_field_reader.dart';
import 'package:trench_warfare/screens/game_field_screen/model/readers/metadata/dto/map_metadata.dart';
import 'package:trench_warfare/screens/game_field_screen/model/readers/metadata/metadata_reader.dart';
import 'package:tuple/tuple.dart';

class GameFieldModel {
  GameFieldModel();

  late final MapMetadata metadata;
  late final GameFieldReadOnly gameField;

  Future<void> init(RenderableTiledMap tileMap) async {
    metadata = await compute(MetadataReader.read, tileMap.map);
    gameField = await compute(GameFieldReader.read, Tuple2<Vector2, TiledMap>(tileMap.destTileSize, tileMap.map));
  }
}