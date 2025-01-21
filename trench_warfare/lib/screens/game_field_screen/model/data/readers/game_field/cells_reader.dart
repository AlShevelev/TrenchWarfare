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
            col * tileSize.x - (col * tileSize.x / 4) + tileSize.x / 2, // x
            row * tileSize.y + tileSize.y / 2 + (col.isEven ? 0 : tileSize.y / 2) // y
          ),
          row: row,
          col: col,
        ),
      );
    }

    return result;
  }

  static CellTerrain _decodeTerrain(int terrainTileIndex) => switch (terrainTileIndex) {
        2 => CellTerrain.water,
        1 => CellTerrain.snow,
        3 => CellTerrain.sand,
        >= 26 && <= 28 => CellTerrain.plain,
        >= 17 && <= 25 => CellTerrain.wood,
        >= 4 && <= 6 => CellTerrain.marsh,
        >= 12 && <= 16 => CellTerrain.hills,
        >= 7 && <= 11 => CellTerrain.mountains,
        _ => throw FormatException('This tile index is unsupported: $terrainTileIndex')
      };

  static bool _hasRiver(int terrainTileIndex) => terrainTileIndex >= 29 && terrainTileIndex <= 47;

  static bool _hasRoad(int terrainTileIndex) =>
      terrainTileIndex >= 48 && terrainTileIndex <= 63 || terrainTileIndex >= 29 && terrainTileIndex <= 31;
}
