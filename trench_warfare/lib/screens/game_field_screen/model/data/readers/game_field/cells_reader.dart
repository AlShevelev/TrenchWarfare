import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:trench_warfare/core/entities/game_field/game_field_library.dart';
import 'package:trench_warfare/core/enums/cell_terrain.dart';

class CellsReader {
  static List<GameFieldCell> read(Vector2 tileSize, TiledMap map) {
    final rows = map.width;
    final cols = map.height;

    final terrainLayer = map.layerByName("Terrain") as TileLayer;
    final roadsAndRiversLayer = map.layerByName("RoadsAndRivers") as TileLayer;

    final result = List<GameFieldCell>.empty(growable: true);

    for (var i = 0; i < terrainLayer.data!.length; i++) {
      final row = i ~/ rows;
      final col = i % cols;

      result.add(
        GameFieldCell(
          terrain: _decodeTerrain(terrainLayer.data![i]),
          hasRiver: _hasRiver(roadsAndRiversLayer.data![i]),
          hasRoad: _hasRoad(roadsAndRiversLayer.data![i]),
          center: Vector2(
            col * tileSize.x + tileSize.x / 2 + (row.isEven ? 0 : tileSize.x / 2), // x
            row * tileSize.y - (row * tileSize.y / 4) + tileSize.y / 2, // y
          ),
          row: row,
          col: col,
        ),
      );
    }

    return result;
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

  static bool _hasRiver(int terrainTileIndex) => _inRange(terrainTileIndex, 59, 114);

  static bool _hasRoad(int terrainTileIndex) =>
      _inRange(terrainTileIndex, 9, 58) || _inRange(terrainTileIndex, 109, 114);

  static bool _inRange(int value, int start, int end) => value >= start && value <= end;
}
