/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:trench_warfare/screens/game_field_screen/model/data/readers/game_field/cells_raw_game_object_merger.dart';
import 'package:trench_warfare/screens/game_field_screen/model/data/readers/game_field/cells_reader.dart';
import 'package:trench_warfare/core/entities/game_field/game_field_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/data/readers/game_field/game_field_assembler.dart';
import 'package:trench_warfare/screens/game_field_screen/model/data/readers/game_field/game_field_validator.dart';
import 'package:trench_warfare/screens/game_field_screen/model/data/readers/game_field/raw_game_objects_reader.dart';
import 'package:tuple/tuple.dart';

class GameFieldReader {
  static GameField read(Tuple2<Vector2, TiledMap> source) {
    final tileSize = source.item1;
    final map = source.item2;

    final cells = CellsReader.read(tileSize, map);
    final gameObjects = RawGameObjectReader.read(map);
    final cellsWithObjects = CellsRawGameObjectMerger.merge(cells, gameObjects);

    final gameField = GameFieldAssembler.assemble(cells, gameObjects, cellsWithObjects);

    GameFieldValidator.validate(gameField);

    return gameField;
  }
}
