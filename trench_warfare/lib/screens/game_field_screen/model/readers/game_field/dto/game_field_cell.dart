import 'dart:ffi';
import 'dart:ui';

import 'package:trench_warfare/core_entities/cell_terrain.dart';
import 'package:trench_warfare/screens/game_field_screen/model/readers/game_field/dto/game_object.dart';

class GameFieldCell {
  /// Center of the cell in map coordinates
  final Offset center;

  final int row;
  final int col;

  final CellTerrain terrain;

  final bool hasRiver;
  final bool hasRoad;

  final List<GameObject> _gameObjects = [];
  Iterable<GameObject> get gameObjects => _gameObjects;

  GameFieldCell({
    required this.terrain,
    required this.hasRiver,
    required this.hasRoad,
    required this.center,
    required this.row,
    required this.col,
  });
}
