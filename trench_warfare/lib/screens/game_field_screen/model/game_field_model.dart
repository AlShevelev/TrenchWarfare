import 'package:flame_tiled/flame_tiled.dart';
import 'package:trench_warfare/screens/game_field_screen/model/readers/game_field/game_field_reader.dart';
import 'package:trench_warfare/screens/game_field_screen/model/readers/metadata/dto/map_metadata.dart';
import 'package:trench_warfare/screens/game_field_screen/model/readers/metadata/metadata_reader.dart';

class GameFieldModel {
  GameFieldModel();

  late final MapMetadata metadata;

  void init(RenderableTiledMap tileMap) {
    metadata = MetadataReader.read(tileMap.map);

    GameFieldReader.read(tileMap);
  }
}