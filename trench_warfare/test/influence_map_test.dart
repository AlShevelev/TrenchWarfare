import 'package:flame/components.dart';
import 'package:test/test.dart';
import 'package:trench_warfare/core_entities/entities/game_objects/game_object.dart';
import 'package:trench_warfare/core_entities/enums/cell_terrain.dart';
import 'package:trench_warfare/core_entities/enums/nation.dart';
import 'package:trench_warfare/core_entities/enums/unit_type.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/game_field/game_field_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/player/influence_map/influence_map_library.dart';

import 'assert.dart';

GameField _createEmptyGameField(CellTerrain Function(int, int) terrainAction) {
  const rows = 7;
  const cols = 7;

  final List<GameFieldCell> cells = [];
  for (var i = 0; i < rows; i++) {
    for (var j = 0; j < cols; j++) {
      cells.add(
          GameFieldCell(
            terrain: terrainAction(i, j),
            hasRiver: false,
            hasRoad: false,
            center: Vector2.zero(),
            row: i,
            col: j,
          )
      );
    }
  }

  return GameField(cells, rows: rows, cols: cols);
}

InfluenceMapRepresentation _createEmptyInfluenceMap() => InfluenceMapRepresentation();

void assertLand(InfluenceMapItemRead item, Nation nation, {double? power}) {
  Assert.isNull(item.getCarrier(nation));
  Assert.isNull(item.getSea(nation));

  if (power != null) {
    Assert.equalsDouble(expected: item.getLand(nation)!, actual: power);
  } else {
    Assert.isNull(item.getLand(nation));
  }
}

void assertSea(InfluenceMapItemRead item, Nation nation, {double? power}) {
  Assert.isNull(item.getCarrier(nation));
  Assert.isNull(item.getLand(nation));

  if (power != null) {
    Assert.equalsDouble(expected: item.getSea(nation)!, actual: power);
  } else {
    Assert.isNull(item.getSea(nation));
  }
}

void assertCarrier(InfluenceMapItemRead item, Nation nation, {double? power}) {
  Assert.isNull(item.getLand(nation));
  Assert.isNull(item.getSea(nation));

  if (power != null) {
    Assert.equalsDouble(expected: item.getCarrier(nation)!, actual: power);
  } else {
    Assert.isNull(item.getCarrier(nation));
  }
}

void main() {
  group('Influence map tests', () {
    test('one land unit', () {
      // Arrange
      final gameField = _createEmptyGameField((row, col) => CellTerrain.plain);
      final map = _createEmptyInfluenceMap();

      const nation = Nation.usa;

      final unitCell = gameField.getCell(3, 3);
      unitCell.addUnit(Unit.byType(UnitType.infantry));
      unitCell.setNation(nation);

      // Act
      map.calculate(gameField);

      // Assert
      assertLand(map.getItem(3, 3), nation, power: 6);

      final radius1Cells = gameField.findCellsAround(unitCell);
      for (final cell in radius1Cells) {
        assertLand(map.getItem(cell.row, cell.col), nation, power: 4);
      }

      final radius2Cells = gameField.findCellsAroundR(unitCell, radius: 2);
      for (final cell in radius2Cells) {
        assertLand(map.getItem(cell.row, cell.col), nation, power: 2);
      }

      final radius3Cells = gameField.findCellsAroundR(unitCell, radius: 3);
      for (final cell in radius3Cells) {
        assertLand(map.getItem(cell.row, cell.col), nation, power: null);
      }
    });

    test('two land units on the same cell', () {
      // Arrange
      final gameField = _createEmptyGameField((row, col) => CellTerrain.plain);
      final map = _createEmptyInfluenceMap();

      const nation = Nation.usa;

      final unitCell = gameField.getCell(3, 3);
      unitCell.addUnit(Unit.byType(UnitType.infantry));
      unitCell.addUnit(Unit.byType(UnitType.infantry));
      unitCell.setNation(nation);

      // Act
      map.calculate(gameField);

      // Assert
      assertLand(map.getItem(3, 3), nation, power: 12);

      final radius1Cells = gameField.findCellsAround(unitCell);
      for (final cell in radius1Cells) {
        assertLand(map.getItem(cell.row, cell.col), nation, power: 8);
      }

      final radius2Cells = gameField.findCellsAroundR(unitCell, radius: 2);
      for (final cell in radius2Cells) {
        assertLand(map.getItem(cell.row, cell.col), nation, power: 4);
      }

      final radius3Cells = gameField.findCellsAroundR(unitCell, radius: 3);
      for (final cell in radius3Cells) {
        assertLand(map.getItem(cell.row, cell.col), nation, power: null);
      }
    });

    test('two land units on different cells', () {
      // Arrange
      final gameField = _createEmptyGameField((row, col) => CellTerrain.plain);
      final map = _createEmptyInfluenceMap();

      const nation = Nation.usa;

      final unitCell = gameField.getCell(3, 2);
      unitCell.addUnit(Unit.byType(UnitType.infantry));
      unitCell.setNation(nation);

      final unit2Cell = gameField.getCell(3, 4);
      unit2Cell.addUnit(Unit.byType(UnitType.infantry));
      unit2Cell.setNation(nation);

      // Act
      map.calculate(gameField);

      // Assert
      assertLand(map.getItem(2, 3), nation, power: 6);
      assertLand(map.getItem(3, 1), nation, power: 4);
      assertLand(map.getItem(3, 2), nation, power: 8);
      assertLand(map.getItem(3, 3), nation, power: 8);
      assertLand(map.getItem(3, 4), nation, power: 8);
      assertLand(map.getItem(3, 5), nation, power: 4);
      assertLand(map.getItem(4, 4), nation, power: 6);
    });

    test('two land units of different nations', () {
      // Arrange
      final gameField = _createEmptyGameField((row, col) => CellTerrain.plain);
      final map = _createEmptyInfluenceMap();

      const nation1 = Nation.usNorth;
      final unit1Cell = gameField.getCell(3, 2);
      unit1Cell.addUnit(Unit.byType(UnitType.infantry));
      unit1Cell.setNation(nation1);

      const nation2 = Nation.usSouth;
      final unit2Cell = gameField.getCell(3, 4);
      unit2Cell.addUnit(Unit.byType(UnitType.infantry));
      unit2Cell.setNation(nation2);

      // Act
      map.calculate(gameField);

      // Assert
      assertLand(map.getItem(unit1Cell.row, unit1Cell.col), nation1, power: 6);

      final radius1Cells1 = gameField.findCellsAround(unit1Cell);
      for (final cell in radius1Cells1) {
        assertLand(map.getItem(cell.row, cell.col), nation1, power: 4);
      }

      final radius2Cells1 = gameField.findCellsAroundR(unit1Cell, radius: 2);
      for (final cell in radius2Cells1) {
        assertLand(map.getItem(cell.row, cell.col), nation1, power: 2);
      }

      final radius3Cells1 = gameField.findCellsAroundR(unit1Cell, radius: 3);
      for (final cell in radius3Cells1) {
        assertLand(map.getItem(cell.row, cell.col), nation1, power: null);
      }


      assertLand(map.getItem(unit2Cell.row, unit2Cell.col), nation2, power: 6);

      final radius1Cells2 = gameField.findCellsAround(unit2Cell);
      for (final cell in radius1Cells2) {
        assertLand(map.getItem(cell.row, cell.col), nation2, power: 4);
      }

      final radius2Cells2 = gameField.findCellsAroundR(unit2Cell, radius: 2);
      for (final cell in radius2Cells2) {
        assertLand(map.getItem(cell.row, cell.col), nation2, power: 2);
      }

      final radius3Cells2 = gameField.findCellsAroundR(unit2Cell, radius: 3);
      for (final cell in radius3Cells2) {
        assertLand(map.getItem(cell.row, cell.col), nation2, power: null);
      }
    });

    test('one sea unit', () {
      // Arrange
      final gameField = _createEmptyGameField((row, col) => CellTerrain.water);
      final map = _createEmptyInfluenceMap();

      const nation = Nation.usa;

      final unitCell = gameField.getCell(3, 3);
      unitCell.addUnit(Unit.byType(UnitType.battleship));
      unitCell.setNation(nation);

      // Act
      map.calculate(gameField);

      // Assert
      assertSea(map.getItem(3, 3), nation, power: 85);

      final radius1Cells = gameField.findCellsAround(unitCell);
      for (final cell in radius1Cells) {
        assertSea(map.getItem(cell.row, cell.col), nation, power: 85 * 2.0 / 3);
      }

      final radius2Cells = gameField.findCellsAroundR(unitCell, radius: 2);
      for (final cell in radius2Cells) {
        assertSea(map.getItem(cell.row, cell.col), nation, power: 85 / 3.0);
      }

      final radius3Cells = gameField.findCellsAroundR(unitCell, radius: 3);
      for (final cell in radius3Cells) {
        assertSea(map.getItem(cell.row, cell.col), nation, power: null);
      }
    });

    test('one empty carrier', () {
      // Arrange
      final gameField = _createEmptyGameField((row, col) => CellTerrain.water);
      final map = _createEmptyInfluenceMap();

      const nation = Nation.usa;

      final unitCell = gameField.getCell(3, 3);
      unitCell.addUnit(Carrier.create());
      unitCell.setNation(nation);

      // Act
      map.calculate(gameField);

      // Assert
      assertCarrier(map.getItem(3, 3), nation, power: 1);

      final radius1Cells = gameField.findCellsAround(unitCell);
      for (final cell in radius1Cells) {
        assertCarrier(map.getItem(cell.row, cell.col), nation, power: 0.75);
      }

      final radius2Cells = gameField.findCellsAroundR(unitCell, radius: 2);
      for (final cell in radius2Cells) {
        assertCarrier(map.getItem(cell.row, cell.col), nation, power: 0.5);
      }

      final radius3Cells = gameField.findCellsAroundR(unitCell, radius: 3);
      for (final cell in radius3Cells) {
        assertCarrier(map.getItem(cell.row, cell.col), nation, power: 0.25);
      }

      final radius4Cells = gameField.findCellsAroundR(unitCell, radius: 4);
      for (final cell in radius4Cells) {
        assertCarrier(map.getItem(cell.row, cell.col), nation, power: null);
      }
    });

    test('two carriers with units', () {
      // Arrange
      final gameField = _createEmptyGameField((row, col) => CellTerrain.water);
      final map = _createEmptyInfluenceMap();

      const nation = Nation.usa;

      final unitCell = gameField.getCell(3, 3);
      unitCell.addUnit(
          Carrier.create()
            ..addUnitAsActive(Unit.byType(UnitType.infantry))
            ..addUnitAsActive(Unit.byType(UnitType.infantry))
      );
      unitCell.addUnit(
          Carrier.create()
            ..addUnitAsActive(Unit.byType(UnitType.infantry))
            ..addUnitAsActive(Unit.byType(UnitType.infantry))
      );
      unitCell.setNation(nation);

      // Act
      map.calculate(gameField);

      // Assert
      assertCarrier(map.getItem(3, 3), nation, power: 24);

      final radius1Cells = gameField.findCellsAround(unitCell);
      for (final cell in radius1Cells) {
        assertCarrier(map.getItem(cell.row, cell.col), nation, power: 18);
      }

      final radius2Cells = gameField.findCellsAroundR(unitCell, radius: 2);
      for (final cell in radius2Cells) {
        assertCarrier(map.getItem(cell.row, cell.col), nation, power: 12);
      }

      final radius3Cells = gameField.findCellsAroundR(unitCell, radius: 3);
      for (final cell in radius3Cells) {
        assertCarrier(map.getItem(cell.row, cell.col), nation, power: 6);
      }

      final radius4Cells = gameField.findCellsAroundR(unitCell, radius: 4);
      for (final cell in radius4Cells) {
        assertCarrier(map.getItem(cell.row, cell.col), nation, power: null);
      }
    });
  });
}
