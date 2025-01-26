import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:trench_warfare/core/entities/game_field/game_field_library.dart';
import 'package:trench_warfare/core/enums/cell_terrain.dart';
import 'package:trench_warfare/shared/utils/math.dart';

class CellsReader {
  static List<GameFieldCell> read(Vector2 tileSize, TiledMap map) {
    final cols = map.width;
    final rows = map.height;

    final terrainLayer = map.layerByName("Terrain") as TileLayer;
    final roadsAndRiversLayer = map.layerByName("RoadsAndRivers") as TileLayer;

    final result = List<GameFieldCell>.empty(growable: true);

    final a = InGameMath.getHexAFactor(tileSize);
    final b = InGameMath.getHexBFactor(tileSize);
    final c = InGameMath.getHexCFactor(tileSize);

    var i = 0;
    for (var row = 0; row < rows; row++) {
      for (var col = 0; col < cols; col++) {
        result.add(
          GameFieldCell(
            terrain: _decodeTerrain(terrainLayer.data![i]),
            hasRiver: _hasRiver(roadsAndRiversLayer.data![i]),
            hasRoad: _hasRoad(roadsAndRiversLayer.data![i]),
            center: Vector2(
                (tileSize.x / 2) + (col * (b + c)),
                a + (row * tileSize.y) + (col.isOdd ? a : 0),
            ),
            row: row,
            col: col,
          ),
        );
        i++;
      }
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
