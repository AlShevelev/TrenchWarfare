import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/foundation.dart';
import 'package:trench_warfare/core_entities/entities/game_field.dart';
import 'package:trench_warfare/core_entities/entities/game_field_cell.dart';
import 'package:trench_warfare/core_entities/entities/game_object.dart';
import 'package:trench_warfare/core_entities/enums/terrain_modifier_type.dart';
import 'package:trench_warfare/screens/game_field_screen/model/algs/find_cell_by_position.dart';
import 'package:trench_warfare/screens/game_field_screen/model/algs/find_path.dart';
import 'package:trench_warfare/screens/game_field_screen/model/readers/game_field/game_field_reader.dart';
import 'package:trench_warfare/screens/game_field_screen/model/readers/metadata/dto/map_metadata.dart';
import 'package:trench_warfare/screens/game_field_screen/model/readers/metadata/metadata_reader.dart';
import 'package:trench_warfare/screens/game_field_screen/model/update_game_event.dart';
import 'package:trench_warfare/shared/architecture/disposable.dart';
import 'package:trench_warfare/shared/architecture/simple_stream.dart';
import 'package:tuple/tuple.dart';

class GameFieldModel implements Disposable {
  GameFieldModel();

  late final MapMetadata metadata;
  late final GameFieldReadOnly gameField;

  final SimpleStream<UpdateGameEvent> _updateGameObjectsEvent = SimpleStream<UpdateGameEvent>();
  Stream<UpdateGameEvent> get updateGameObjectsEvent => _updateGameObjectsEvent.output;

  GameFieldCell? _start;

  Future<void> init(RenderableTiledMap tileMap) async {
    metadata = await compute(MetadataReader.read, tileMap.map);
    gameField = await compute(GameFieldReader.read, Tuple2<Vector2, TiledMap>(tileMap.destTileSize, tileMap.map));

    final cellsToAdd = gameField.cells.where((c) => !c.isEmpty);
    _updateGameObjectsEvent.update(AddObjects(cellsToAdd));
  }

/*
  void onClick(Vector2 position) {
    final clickedCell = FindCellByPosition.find(gameField, position);
    //print("cell: ${clickedCell.row}, ${clickedCell.col}");

    clickedCell.setTerrainModifier(TerrainModifier(type: TerrainModifierType.seaMine));
    _updateGameObjectsEvent.update(AddObjects([clickedCell]));
  }
*/

/*
  void onClick(Vector2 position) {
    final clickedCell = FindCellByPosition.find(gameField, position);

    final cellsAround = FindCellsAround.find(gameField, clickedCell);

    for (var cell in cellsAround) {
      cell.setTerrainModifier(TerrainModifier(type: TerrainModifierType.landFort));
    }
    _updateGameObjectsEvent.update(AddObjects(cellsAround));
  }
*/

  void onClick(Vector2 position) {
    final clickedCell = FindCellByPosition.find(gameField, position);

    if (_start == null) {
      _start = clickedCell;
    } else {
      final findPath = FindPath(gameField, FindPathGFactorHeuristic());
      final path = findPath.find(_start!, clickedCell);

      for (var cell in path) {
        cell.setTerrainModifier(TerrainModifier(type: TerrainModifierType.barbedWire));
      }
      _updateGameObjectsEvent.update(AddObjects(path));

      _start = null;
    }
  }

  @override
  void dispose() {
    _updateGameObjectsEvent.close();
  }
}