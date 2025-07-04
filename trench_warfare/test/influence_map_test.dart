import 'package:flame/components.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:trench_warfare/core/entities/game_objects/game_object_library.dart';
import 'package:trench_warfare/core/enums/cell_terrain.dart';
import 'package:trench_warfare/core/enums/nation.dart';
import 'package:trench_warfare/core/enums/unit_type.dart';
import 'package:trench_warfare/core/entities/game_field/game_field_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/data/readers/metadata/dto/map_metadata.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/player/influence_map/influence_map_library.dart';

import 'assert.dart';
import 'influence_map_test.mocks.dart';

@GenerateMocks([MapMetadataRead])
void main() {
  GameField createEmptyGameField(CellTerrain Function(int, int) terrainAction) {
    const rows = 7;
    const cols = 7;

    final List<GameFieldCell> cells = [];
    for (var i = 0; i < rows; i++) {
      for (var j = 0; j < cols; j++) {
        cells.add(GameFieldCell(
          terrain: terrainAction(i, j),
          hasRiver: false,
          hasRoad: false,
          center: Vector2.zero(),
          row: i,
          col: j,
        ));
      }
    }

    return GameField(cells, rows: rows, cols: cols);
  }

  InfluenceMapRepresentation createEmptyInfluenceMap(Nation nation, MapMetadataRead metadata) =>
    InfluenceMapRepresentation(
        myNation: nation,
        metadata: metadata,
    );

  void assertLand(InfluenceMapItemRead item, Nation nation, {double? power}) {
    Assert.isNull(item.getCarrier(nation));
    Assert.isNull(item.getSea(nation));

    if (power != null) {
      Assert.equalsDouble(expected: power, actual: item.getLand(nation)!);
    } else {
      Assert.isNull(item.getLand(nation));
    }
  }

  void assertSea(InfluenceMapItemRead item, Nation nation, {double? power}) {
    Assert.isNull(item.getCarrier(nation));
    Assert.isNull(item.getLand(nation));

    if (power != null) {
      Assert.equalsDouble(expected: power, actual: item.getSea(nation)!);
    } else {
      Assert.isNull(item.getSea(nation));
    }
  }

  void assertCarrier(InfluenceMapItemRead item, Nation nation, {double? power}) {
    Assert.isNull(item.getLand(nation));
    Assert.isNull(item.getSea(nation));

    if (power != null) {
      Assert.equalsDouble(expected: power, actual: item.getCarrier(nation)!);
    } else {
      Assert.isNull(item.getCarrier(nation));
    }
  }

  void assertLandEquals(InfluenceMapItemRead item1, InfluenceMapItemRead item2, Nation nation) {
    final land1Value = item1.getLand(nation);
    final land2Value = item2.getLand(nation);

    if ((land1Value == null && land2Value != null) || (land1Value != null && land2Value == null)) {
      Assert.isTrue(false);
      return;
    }

    if (land1Value == null && land2Value == null) {
      Assert.isTrue(true);
      return;
    }

    Assert.equalsDouble(expected: land1Value!, actual: land2Value!);
  }

  group('Influence map tests', () {
    test('one land unit', () {
      // Arrange
      final gameField = createEmptyGameField((row, col) => CellTerrain.plain);

      const nation = Nation.usa;

      final metadata = MockMapMetadataRead();
      when(metadata.isAlly(nation, nation)).thenReturn(false);
      when(metadata.isAlly(nation, null)).thenReturn(false);

      final map = createEmptyInfluenceMap(nation, metadata);

      final unitCell = gameField.getCell(3, 3);
      unitCell.addUnit(Unit.byType(UnitType.infantry));
      unitCell.setNation(nation);

      // Act
      map.calculateFull(gameField);

      // Assert
      assertLand(map.getItem(3, 3), nation, power: 12);

      final radius1Cells = gameField.findCellsAround(unitCell);
      for (final cell in radius1Cells) {
        assertLand(map.getItem(cell.row, cell.col), nation, power: 9.6);
      }

      final radius2Cells = gameField.findCellsAroundR(unitCell, radius: 2);
      for (final cell in radius2Cells) {
        assertLand(map.getItem(cell.row, cell.col), nation, power: 7.2);
      }

      final radius3Cells = gameField.findCellsAroundR(unitCell, radius: 3);
      for (final cell in radius3Cells) {
        assertLand(map.getItem(cell.row, cell.col), nation, power: 4.8);
      }
    });

    test('two land units on the same cell', () {
      // Arrange
      final gameField = createEmptyGameField((row, col) => CellTerrain.plain);

      const nation = Nation.usa;

      final metadata = MockMapMetadataRead();
      when(metadata.isAlly(nation, nation)).thenReturn(false);
      when(metadata.isAlly(nation, null)).thenReturn(false);

      final map = createEmptyInfluenceMap(nation, metadata);

      final unitCell = gameField.getCell(3, 3);
      unitCell.addUnit(Unit.byType(UnitType.infantry));
      unitCell.addUnit(Unit.byType(UnitType.infantry));
      unitCell.setNation(nation);

      // Act
      map.calculateFull(gameField);

      // Assert
      assertLand(map.getItem(3, 3), nation, power: 24);

      final radius1Cells = gameField.findCellsAround(unitCell);
      for (final cell in radius1Cells) {
        assertLand(map.getItem(cell.row, cell.col), nation, power: 19.2);
      }

      final radius2Cells = gameField.findCellsAroundR(unitCell, radius: 2);
      for (final cell in radius2Cells) {
        assertLand(map.getItem(cell.row, cell.col), nation, power: 14.4);
      }

      final radius3Cells = gameField.findCellsAroundR(unitCell, radius: 3);
      for (final cell in radius3Cells) {
        assertLand(map.getItem(cell.row, cell.col), nation, power: 9.6);
      }
    });

    test('two land units on different cells', () {
      // Arrange
      final gameField = createEmptyGameField((row, col) => CellTerrain.plain);

      const nation = Nation.usa;

      final metadata = MockMapMetadataRead();
      when(metadata.isAlly(nation, nation)).thenReturn(false);
      when(metadata.isAlly(nation, null)).thenReturn(false);

      final map = createEmptyInfluenceMap(nation, metadata);

      final unitCell = gameField.getCell(3, 2);
      unitCell.addUnit(Unit.byType(UnitType.infantry));
      unitCell.setNation(nation);

      final unit2Cell = gameField.getCell(3, 4);
      unit2Cell.addUnit(Unit.byType(UnitType.infantry));
      unit2Cell.setNation(nation);

      // Act
      map.calculateFull(gameField);

      // Assert
      assertLand(map.getItem(2, 3), nation, power: 19.2);
      assertLand(map.getItem(3, 1), nation, power: 14.4);
      assertLand(map.getItem(3, 2), nation, power: 19.2);
      assertLand(map.getItem(3, 3), nation, power: 19.2);
      assertLand(map.getItem(3, 4), nation, power: 19.2);
      assertLand(map.getItem(3, 5), nation, power: 14.4);
      assertLand(map.getItem(4, 4), nation, power: 16.8);
    });

    test('two land units of different nations', () {
      // Arrange
      final gameField = createEmptyGameField((row, col) => CellTerrain.plain);

      const nation1 = Nation.usNorth;
      const nation2 = Nation.usSouth;

      final metadata = MockMapMetadataRead();
      when(metadata.isAlly(nation1, null)).thenReturn(false);
      when(metadata.isAlly(nation1, nation1)).thenReturn(false);
      when(metadata.isAlly(nation1, nation2)).thenReturn(false);

      final map = createEmptyInfluenceMap(nation1, metadata);

      final unit1Cell = gameField.getCell(3, 2);
      unit1Cell.addUnit(Unit.byType(UnitType.infantry));
      unit1Cell.setNation(nation1);

      final unit2Cell = gameField.getCell(3, 4);
      unit2Cell.addUnit(Unit.byType(UnitType.infantry));
      unit2Cell.setNation(nation2);

      // Act
      map.calculateFull(gameField);

      // Assert
      assertLand(map.getItem(unit1Cell.row, unit1Cell.col), nation1, power: 12);

      final radius1Cells1 = gameField.findCellsAround(unit1Cell);
      for (final cell in radius1Cells1) {
        assertLand(map.getItem(cell.row, cell.col), nation1, power: 9.6);
      }

      final radius2Cells1 = gameField.findCellsAroundR(unit1Cell, radius: 2);
      for (final cell in radius2Cells1) {
        assertLand(map.getItem(cell.row, cell.col), nation1, power: 7.2);
      }

      final radius3Cells1 = gameField.findCellsAroundR(unit1Cell, radius: 3);
      for (final cell in radius3Cells1) {
        assertLand(map.getItem(cell.row, cell.col), nation1, power: 4.8);
      }

      assertLand(map.getItem(unit2Cell.row, unit2Cell.col), nation2, power: 12);

      final radius1Cells2 = gameField.findCellsAround(unit2Cell);
      for (final cell in radius1Cells2) {
        assertLand(map.getItem(cell.row, cell.col), nation2, power: 9.6);
      }

      final radius2Cells2 = gameField.findCellsAroundR(unit2Cell, radius: 2);
      for (final cell in radius2Cells2) {
        assertLand(map.getItem(cell.row, cell.col), nation2, power: 7.2);
      }

      final radius3Cells2 = gameField.findCellsAroundR(unit2Cell, radius: 3);
      for (final cell in radius3Cells2) {
        assertLand(map.getItem(cell.row, cell.col), nation2, power: 4.8);
      }
    });

    test('one sea unit', () {
      // Arrange
      final gameField = createEmptyGameField((row, col) => CellTerrain.water);

      const nation = Nation.usa;

      final metadata = MockMapMetadataRead();
      when(metadata.isAlly(nation, nation)).thenReturn(false);
      when(metadata.isAlly(nation, null)).thenReturn(false);

      final map = createEmptyInfluenceMap(nation, metadata);

      final unitCell = gameField.getCell(3, 3);
      unitCell.addUnit(Unit.byType(UnitType.battleship));
      unitCell.setNation(nation);

      // Act
      map.calculateFull(gameField);

      // Assert
      assertSea(map.getItem(3, 3), nation, power: 170);

      final radius1Cells = gameField.findCellsAround(unitCell);
      for (final cell in radius1Cells) {
        assertSea(map.getItem(cell.row, cell.col), nation, power: 127.5);
      }

      final radius2Cells = gameField.findCellsAroundR(unitCell, radius: 2);
      for (final cell in radius2Cells) {
        assertSea(map.getItem(cell.row, cell.col), nation, power: 85);
      }

      final radius3Cells = gameField.findCellsAroundR(unitCell, radius: 3);
      for (final cell in radius3Cells) {
        assertSea(map.getItem(cell.row, cell.col), nation, power: 42.5);
      }

      final radius4Cells = gameField.findCellsAroundR(unitCell, radius: 4);
      for (final cell in radius4Cells) {
        assertSea(map.getItem(cell.row, cell.col), nation, power: null);
      }
    });

    test('one empty carrier', () {
      // Arrange
      final gameField = createEmptyGameField((row, col) => CellTerrain.water);

      const nation = Nation.usa;

      final metadata = MockMapMetadataRead();
      when(metadata.isAlly(nation, nation)).thenReturn(false);
      when(metadata.isAlly(nation, null)).thenReturn(false);

      final map = createEmptyInfluenceMap(nation, metadata);

      final unitCell = gameField.getCell(3, 3);
      unitCell.addUnit(Carrier.create());
      unitCell.setNation(nation);

      // Act
      map.calculateFull(gameField);

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
      final gameField = createEmptyGameField((row, col) => CellTerrain.water);

      const nation = Nation.usa;

      final metadata = MockMapMetadataRead();
      when(metadata.isAlly(nation, nation)).thenReturn(false);
      when(metadata.isAlly(nation, null)).thenReturn(false);

      final map = createEmptyInfluenceMap(nation, metadata);

      final unitCell = gameField.getCell(3, 3);
      unitCell.addUnit(Carrier.create()
        ..addUnitAsActive(Unit.byType(UnitType.infantry))
        ..addUnitAsActive(Unit.byType(UnitType.infantry)));
      unitCell.addUnit(Carrier.create()
        ..addUnitAsActive(Unit.byType(UnitType.infantry))
        ..addUnitAsActive(Unit.byType(UnitType.infantry)));
      unitCell.setNation(nation);

      // Act
      map.calculateFull(gameField);

      // Assert
      assertCarrier(map.getItem(3, 3), nation, power: 48);

      final radius1Cells = gameField.findCellsAround(unitCell);
      for (final cell in radius1Cells) {
        assertCarrier(map.getItem(cell.row, cell.col), nation, power: 36);
      }

      final radius2Cells = gameField.findCellsAroundR(unitCell, radius: 2);
      for (final cell in radius2Cells) {
        assertCarrier(map.getItem(cell.row, cell.col), nation, power: 24);
      }

      final radius3Cells = gameField.findCellsAroundR(unitCell, radius: 3);
      for (final cell in radius3Cells) {
        assertCarrier(map.getItem(cell.row, cell.col), nation, power: 12);
      }

      final radius4Cells = gameField.findCellsAroundR(unitCell, radius: 4);
      for (final cell in radius4Cells) {
        assertCarrier(map.getItem(cell.row, cell.col), nation, power: null);
      }
    });
  });

  group('recalculation', () {
    test('two land units on different cells', () {
      // Arrange
      final gameField = createEmptyGameField((row, col) => CellTerrain.plain);

      const nation = Nation.usa;

      final metadata = MockMapMetadataRead();
      when(metadata.isAlly(nation, nation)).thenReturn(false);
      when(metadata.isAlly(nation, null)).thenReturn(false);

      final unit = Unit.byType(UnitType.infantry);

      final unitCell = gameField.getCell(3, 2);
      unitCell.addUnit(unit);
      unitCell.setNation(nation);

      final unit2Cell = gameField.getCell(3, 4);
      unit2Cell.addUnit(unit);
      unit2Cell.setNation(nation);

      // Act
      final map1 = createEmptyInfluenceMap(nation, metadata)..calculateFull(gameField);

      final map2 = createEmptyInfluenceMap(nation, metadata)..calculateFull(gameField);
      map2.removeUnit(Unit.copy(unit), nation, unitCell);
      map2.addUnit(Unit.copy(unit), nation, unitCell);

      // Assert
      for (var row = 0; row < gameField.rows; row++) {
        for (var col = 0; col < gameField.cols; col++) {
          final item1 = map1.getItem(row, col);
          final item2 = map2.getItem(row, col);

          assertLandEquals(item1, item2, nation);
        }
      }
    });
  });
}
