import 'dart:ui';

import 'package:flame_tiled/flame_tiled.dart';
import 'package:trench_warfare/core_entities/cell_terrain.dart';
import 'package:trench_warfare/screens/game_field_screen/model/readers/game_field/dto/game_field.dart';
import 'package:trench_warfare/screens/game_field_screen/model/readers/game_field/dto/game_field_cell.dart';

class GameFieldReader {
  static GameFieldReadOnly read(RenderableTiledMap tileMap) {
    final map = tileMap.map;

    final tileSize = tileMap.destTileSize;

    final rows = map.width;
    final cols = map.height;

    final gameField = GameField(rows: rows, cols: cols);

    final terrainLayer = map.layerByName("Terrain") as TileLayer;
    final roadsAndRiversLayer = map.layerByName("RoadsAndRivers") as TileLayer;

    for (var i = 0; i < terrainLayer.data!.length; i++) {
      final row = i ~/ rows;
      final col = i % cols;

      gameField.setCellByIndex(
        i,
        GameFieldCell(
          terrain: _decodeTerrain(terrainLayer.data![i]),
          hasRiver: _hasRiver(roadsAndRiversLayer.data![i]),
          hasRoad: _hasRoad(roadsAndRiversLayer.data![i]),
          center: Offset(
            col * tileSize.x + tileSize.x / 2 + (row.isEven ? 0 : tileSize.x / 2), // x
            row * tileSize.y - (row * tileSize.y / 4) + tileSize.y / 2, // y
          ),
          row: row,
          col: col,
        ),
      );
    }

    final gameObjectLayer = map.layerByName("GameObjects") as ObjectGroup;
    final p = gameObjectLayer.objects[0].properties.byName;

    return gameField;
  }

  static CellTerrain _decodeTerrain(int terrainTileIndex) {
    switch (terrainTileIndex) {
      case 1:
        return CellTerrain.water;
      case 2:
        return CellTerrain.snow;
      case 3:
        return CellTerrain.sand;
      case 4:
        return CellTerrain.plain;
      case 5:
        return CellTerrain.wood;
      case 6:
        return CellTerrain.marsh;
      case 7:
        return CellTerrain.hills;
      case 8:
        return CellTerrain.mountains;
      default:
        throw FormatException('This tile index is unsupported: $terrainTileIndex');
    }
  }

  static bool _hasRiver(int terrainTileIndex) => _inRange(terrainTileIndex, 9, 26) || _inRange(terrainTileIndex, 64, 71);

  static bool _hasRoad(int terrainTileIndex) => _inRange(terrainTileIndex, 27, 69) || _inRange(terrainTileIndex, 72, 73);

  static bool _inRange(int value, int start, int end) => value >= start && value <= end;
}
