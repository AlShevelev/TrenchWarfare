import 'package:flame_tiled/flame_tiled.dart';
import 'package:trench_warfare/screens/game_field_screen/model/map_reader/dto/map_metadata.dart';
import 'package:trench_warfare/screens/game_field_screen/model/map_reader/map_reader.dart';

class GameFieldModel {
  GameFieldModel();

  late final MapMetadata metadata;

  void init(TiledMap map) {
    final reader = MapReader(map);

    metadata = reader.readMetadata();
  }
}