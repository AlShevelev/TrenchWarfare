import 'package:flame/components.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:trench_warfare/core_entities/entities/game_objects/game_object.dart';
import 'package:trench_warfare/core_entities/enums/cell_terrain.dart';
import 'package:trench_warfare/core_entities/enums/nation.dart';
import 'package:trench_warfare/core_entities/enums/unit_type.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/game_field/game_field_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/player/ai/aggressive/phases/units_moving/units_moving_phase_library.dart';

import 'assert.dart';

import 'stable_units_interator_test.mocks.dart';

@GenerateMocks([GameFieldRead])
void main() {
  group('StableUnitsIterator - shifted', () {
    test('shifted', () {
      // Arrange
      const cellsTotal = 10;

      final cells = [for (var i = 0; i < cellsTotal; i++) i]
          .map(
            (i) => GameFieldCell(
              terrain: CellTerrain.plain,
              hasRiver: false,
              hasRoad: false,
              center: Vector2.zero(),
              row: 0,
              col: i,
            )
              ..setNation(Nation.usa)
              ..addUnit(Unit.byType(UnitType.infantry)),
          )
          .toList(growable: false);

      final mockGameField = MockGameFieldRead();
      when(mockGameField.cells).thenReturn(cells);

      // Act
      final iterator = StableUnitsIterator(
        gameField: mockGameField,
        myNation: Nation.usa,
        excludedUnits: [],
        shifted: true,
      );

      // Assert
      var counter = 0;
      final ids = <int>{};

      while (iterator.moveNext()) {
        final cell = iterator.current.cell;
        Assert.isTrue(cells.contains(cell));

        ids.add(cell.id);

        counter++;
      }

      Assert.equals(counter, cellsTotal);
      Assert.equals(ids.length, cellsTotal);
    });
  });

  group('StableUnitsIterator - non-shifted', () {
    test('an empty list', () {
      // Arrange
      final cells = <GameFieldCell>[];
      final mockGameField = MockGameFieldRead();
      when(mockGameField.cells).thenReturn(cells);

      // Act
      final iterator = StableUnitsIterator(
        gameField: mockGameField,
        myNation: Nation.usa,
        excludedUnits: [],
        shifted: false,
      );

      // Assert
      var counter = 0;
      while (iterator.moveNext()) {
      }

      Assert.equals(counter, 0);
    });

    test('all the cell without units', () {
      // Arrange
      const cellsTotal = 10;

      final cells = [for (var i = 0; i < cellsTotal; i++) i]
          .map(
            (i) => GameFieldCell(
          terrain: CellTerrain.plain,
          hasRiver: false,
          hasRoad: false,
          center: Vector2.zero(),
          row: 0,
          col: i,
        )
          ..setNation(Nation.usa),
      )
          .toList(growable: false);

      final mockGameField = MockGameFieldRead();
      when(mockGameField.cells).thenReturn(cells);

      // Act
      final iterator = StableUnitsIterator(
        gameField: mockGameField,
        myNation: Nation.usa,
        excludedUnits: [],
        shifted: true,
      );

      // Assert
      var counter = 0;
      while (iterator.moveNext()) {
        counter++;
      }

      Assert.equals(counter, 0);
    });

    test('all the cell without nation', () {
      // Arrange
      const cellsTotal = 10;

      final cells = [for (var i = 0; i < cellsTotal; i++) i]
          .map(
            (i) => GameFieldCell(
          terrain: CellTerrain.plain,
          hasRiver: false,
          hasRoad: false,
          center: Vector2.zero(),
          row: 0,
          col: i,
        )
              ..addUnit(Unit.byType(UnitType.infantry)),
      )
          .toList(growable: false);

      final mockGameField = MockGameFieldRead();
      when(mockGameField.cells).thenReturn(cells);

      // Act
      final iterator = StableUnitsIterator(
        gameField: mockGameField,
        myNation: Nation.usa,
        excludedUnits: [],
        shifted: true,
      );

      // Assert
      var counter = 0;
      while (iterator.moveNext()) {
        counter++;
      }

      Assert.equals(counter, 0);
    });

    test('1 cell with 1 unit', () {
      // Arrange
      final cells = [
        GameFieldCell(
          terrain: CellTerrain.plain,
          hasRiver: false,
          hasRoad: false,
          center: Vector2.zero(),
          row: 0,
          col: 0,
        )
          ..addUnit(Unit.byType(UnitType.infantry))
          ..setNation(Nation.usa),
      ];

      final mockGameField = MockGameFieldRead();
      when(mockGameField.cells).thenReturn(cells);

      // Act
      final iterator = StableUnitsIterator(
        gameField: mockGameField,
        myNation: Nation.usa,
        excludedUnits: [],
        shifted: true,
      );

      // Assert
      var counter = 0;
      while (iterator.moveNext()) {
        final item = iterator.current;
        
        Assert.equals(item.cell, cells[0]);
        Assert.equals(item.unit, cells[0].units.elementAt(0));
        
        counter++;
      }

      Assert.equals(counter, 1);
    });

    test('1 cell with several units', () {
      // Arrange
      final units = [
        Unit.byType(UnitType.infantry),
        Unit.byType(UnitType.infantry),
      ];

      final cells = [
        GameFieldCell(
          terrain: CellTerrain.plain,
          hasRiver: false,
          hasRoad: false,
          center: Vector2.zero(),
          row: 0,
          col: 0,
        )
          ..addUnits(units)
          ..setNation(Nation.usa),
      ];

      final mockGameField = MockGameFieldRead();
      when(mockGameField.cells).thenReturn(cells);

      // Act
      final iterator = StableUnitsIterator(
        gameField: mockGameField,
        myNation: Nation.usa,
        excludedUnits: [],
        shifted: true,
      );

      // Assert
      var counter = 0;
      while (iterator.moveNext()) {
        final item = iterator.current;

        Assert.equals(item.cell, cells[0]);
        Assert.equals(item.unit, cells[0].units.elementAt(counter));

        counter++;
      }

      Assert.equals(counter, 2);
    });

    test('2 cell with one unit', () {
      // Arrange
      final unit1 = Unit.byType(UnitType.infantry);
      final unit2 = Unit.byType(UnitType.infantry);

      final cells = [
        GameFieldCell(
          terrain: CellTerrain.plain,
          hasRiver: false,
          hasRoad: false,
          center: Vector2.zero(),
          row: 0,
          col: 0,
        )
          ..addUnit(unit1)
          ..setNation(Nation.usa),
        GameFieldCell(
          terrain: CellTerrain.plain,
          hasRiver: false,
          hasRoad: false,
          center: Vector2.zero(),
          row: 0,
          col: 1,
        )
          ..addUnit(unit2)
          ..setNation(Nation.usa),
      ];

      final mockGameField = MockGameFieldRead();
      when(mockGameField.cells).thenReturn(cells);

      // Act
      final iterator = StableUnitsIterator(
        gameField: mockGameField,
        myNation: Nation.usa,
        excludedUnits: [],
        shifted: true,
      );

      // Assert
      Assert.isTrue(iterator.moveNext());
      Assert.equals(iterator.current.cell, cells[0]);
      Assert.equals(iterator.current.unit, unit1);

      Assert.isTrue(iterator.moveNext());
      Assert.equals(iterator.current.cell, cells[1]);
      Assert.equals(iterator.current.unit, unit2);

      Assert.isFalse(iterator.moveNext());
    });

    test('2 cell with several units', () {
      // Arrange
      final units1 = [
        Unit.byType(UnitType.infantry),
        Unit.byType(UnitType.infantry),
      ];
      final units2 = [
        Unit.byType(UnitType.infantry),
        Unit.byType(UnitType.infantry),
      ];

      final cells = [
        GameFieldCell(
          terrain: CellTerrain.plain,
          hasRiver: false,
          hasRoad: false,
          center: Vector2.zero(),
          row: 0,
          col: 0,
        )
          ..addUnits(units1)
          ..setNation(Nation.usa),
        GameFieldCell(
          terrain: CellTerrain.plain,
          hasRiver: false,
          hasRoad: false,
          center: Vector2.zero(),
          row: 0,
          col: 1,
        )
          ..addUnits(units2)
          ..setNation(Nation.usa),
      ];

      final mockGameField = MockGameFieldRead();
      when(mockGameField.cells).thenReturn(cells);

      // Act
      final iterator = StableUnitsIterator(
        gameField: mockGameField,
        myNation: Nation.usa,
        excludedUnits: [],
        shifted: true,
      );

      // Assert
      Assert.isTrue(iterator.moveNext());
      Assert.equals(iterator.current.cell, cells[0]);
      Assert.equals(iterator.current.unit, units1[0]);

      Assert.isTrue(iterator.moveNext());
      Assert.equals(iterator.current.cell, cells[0]);
      Assert.equals(iterator.current.unit, units1[1]);

      Assert.isTrue(iterator.moveNext());
      Assert.equals(iterator.current.cell, cells[1]);
      Assert.equals(iterator.current.unit, units2[0]);

      Assert.isTrue(iterator.moveNext());
      Assert.equals(iterator.current.cell, cells[1]);
      Assert.equals(iterator.current.unit, units2[1]);

      Assert.isFalse(iterator.moveNext());
    });

    test('some units have been removed', () {
      // Arrange
      final units1 = [
        Unit.byType(UnitType.infantry),
        Unit.byType(UnitType.infantry),
      ];
      final units2 = [
        Unit.byType(UnitType.infantry),
        Unit.byType(UnitType.infantry),
      ];

      final cells = [
        GameFieldCell(
          terrain: CellTerrain.plain,
          hasRiver: false,
          hasRoad: false,
          center: Vector2.zero(),
          row: 0,
          col: 0,
        )
          ..addUnits(units1)
          ..setNation(Nation.usa),
        GameFieldCell(
          terrain: CellTerrain.plain,
          hasRiver: false,
          hasRoad: false,
          center: Vector2.zero(),
          row: 0,
          col: 1,
        )
          ..addUnits(units2)
          ..setNation(Nation.usa),
      ];

      final mockGameField = MockGameFieldRead();
      when(mockGameField.cells).thenReturn(cells);

      // Act
      final iterator = StableUnitsIterator(
        gameField: mockGameField,
        myNation: Nation.usa,
        excludedUnits: [],
        shifted: true,
      );

      // Assert
      Assert.isTrue(iterator.moveNext());
      Assert.equals(iterator.current.cell, cells[0]);
      Assert.equals(iterator.current.unit, units1[0]);
      cells[0].removeUnit(units1[0]);

      Assert.isTrue(iterator.moveNext());
      Assert.equals(iterator.current.cell, cells[0]);
      Assert.equals(iterator.current.unit, units1[1]);
      cells[0].removeUnit(units1[1]);

      Assert.isTrue(iterator.moveNext());
      Assert.equals(iterator.current.cell, cells[1]);
      Assert.equals(iterator.current.unit, units2[0]);
      cells[1].removeUnit(units2[0]);

      Assert.isTrue(iterator.moveNext());
      Assert.equals(iterator.current.cell, cells[1]);
      Assert.equals(iterator.current.unit, units2[1]);
      cells[1].removeUnit(units2[1]);

      Assert.isFalse(iterator.moveNext());
    });

    test('some units have been resorted', () {
      // Arrange
      final units1 = [
        Unit.byType(UnitType.infantry),
        Unit.byType(UnitType.infantry),
      ];
      final units2 = [
        Unit.byType(UnitType.infantry),
        Unit.byType(UnitType.infantry),
      ];

      final cells = [
        GameFieldCell(
          terrain: CellTerrain.plain,
          hasRiver: false,
          hasRoad: false,
          center: Vector2.zero(),
          row: 0,
          col: 0,
        )
          ..addUnits(units1)
          ..setNation(Nation.usa),
        GameFieldCell(
          terrain: CellTerrain.plain,
          hasRiver: false,
          hasRoad: false,
          center: Vector2.zero(),
          row: 0,
          col: 1,
        )
          ..addUnits(units2)
          ..setNation(Nation.usa),
      ];

      final mockGameField = MockGameFieldRead();
      when(mockGameField.cells).thenReturn(cells);

      // Act
      final iterator = StableUnitsIterator(
        gameField: mockGameField,
        myNation: Nation.usa,
        excludedUnits: [],
        shifted: true,
      );

      // Assert
      Assert.isTrue(iterator.moveNext());
      Assert.equals(iterator.current.cell, cells[0]);
      Assert.equals(iterator.current.unit, units1[0]);

      cells[0].resortUnits([units1[1].id, units1[0].id]);

      Assert.isTrue(iterator.moveNext());
      Assert.equals(iterator.current.cell, cells[0]);
      Assert.equals(iterator.current.unit, units1[1]);

      Assert.isTrue(iterator.moveNext());
      Assert.equals(iterator.current.cell, cells[1]);
      Assert.equals(iterator.current.unit, units2[0]);

      cells[1].resortUnits([units2[1].id, units2[0].id]);

      Assert.isTrue(iterator.moveNext());
      Assert.equals(iterator.current.cell, cells[1]);
      Assert.equals(iterator.current.unit, units2[1]);

      Assert.isFalse(iterator.moveNext());
    });
  });

  group('StableUnitsIterator - with excluded', () {
    test('1 cell with 1 unit - the unit is excluded', () {
      // Arrange
      final cells = [
        GameFieldCell(
          terrain: CellTerrain.plain,
          hasRiver: false,
          hasRoad: false,
          center: Vector2.zero(),
          row: 0,
          col: 0,
        )
          ..addUnit(Unit.byType(UnitType.infantry))
          ..setNation(Nation.usa),
      ];

      final mockGameField = MockGameFieldRead();
      when(mockGameField.cells).thenReturn(cells);

      // Act
      final iterator = StableUnitsIterator(
        gameField: mockGameField,
        myNation: Nation.usa,
        excludedUnits: [cells[0].units.first],
        shifted: true,
      );

      // Assert
      var counter = 0;
      while (iterator.moveNext()) {
        final item = iterator.current;

        Assert.equals(item.cell, cells[0]);
        Assert.equals(item.unit, cells[0].units.elementAt(0));

        counter++;
      }

      Assert.equals(counter, 0);
    });

    test('1 cell with several units - the first one is excluded', () {
      // Arrange
      final units = [
        Unit.byType(UnitType.infantry),
        Unit.byType(UnitType.infantry),
      ];

      final cells = [
        GameFieldCell(
          terrain: CellTerrain.plain,
          hasRiver: false,
          hasRoad: false,
          center: Vector2.zero(),
          row: 0,
          col: 0,
        )
          ..addUnits(units)
          ..setNation(Nation.usa),
      ];

      final mockGameField = MockGameFieldRead();
      when(mockGameField.cells).thenReturn(cells);

      // Act
      final iterator = StableUnitsIterator(
        gameField: mockGameField,
        myNation: Nation.usa,
        excludedUnits: [units[0]],
        shifted: true,
      );

      // Assert
      var counter = 0;
      while (iterator.moveNext()) {
        final item = iterator.current;

        Assert.equals(item.cell, cells[0]);
        Assert.equals(item.unit, cells[0].units.elementAt(1));

        counter++;
      }

      Assert.equals(counter, 1);
    });

    test('1 cell with several units - the last one is excluded', () {
      // Arrange
      final units = [
        Unit.byType(UnitType.infantry),
        Unit.byType(UnitType.infantry),
      ];

      final cells = [
        GameFieldCell(
          terrain: CellTerrain.plain,
          hasRiver: false,
          hasRoad: false,
          center: Vector2.zero(),
          row: 0,
          col: 0,
        )
          ..addUnits(units)
          ..setNation(Nation.usa),
      ];

      final mockGameField = MockGameFieldRead();
      when(mockGameField.cells).thenReturn(cells);

      // Act
      final iterator = StableUnitsIterator(
        gameField: mockGameField,
        myNation: Nation.usa,
        excludedUnits: [units[1]],
        shifted: true,
      );

      // Assert
      var counter = 0;
      while (iterator.moveNext()) {
        final item = iterator.current;

        Assert.equals(item.cell, cells[0]);
        Assert.equals(item.unit, cells[0].units.elementAt(0));

        counter++;
      }

      Assert.equals(counter, 1);
    });

    test('1 cell with several units - all units are excluded', () {
      // Arrange
      final units = [
        Unit.byType(UnitType.infantry),
        Unit.byType(UnitType.infantry),
      ];

      final cells = [
        GameFieldCell(
          terrain: CellTerrain.plain,
          hasRiver: false,
          hasRoad: false,
          center: Vector2.zero(),
          row: 0,
          col: 0,
        )
          ..addUnits(units)
          ..setNation(Nation.usa),
      ];

      final mockGameField = MockGameFieldRead();
      when(mockGameField.cells).thenReturn(cells);

      // Act
      final iterator = StableUnitsIterator(
        gameField: mockGameField,
        myNation: Nation.usa,
        excludedUnits: [units[0], units[1]],
        shifted: true,
      );

      // Assert
      var counter = 0;
      while (iterator.moveNext()) {
        final item = iterator.current;

        Assert.equals(item.cell, cells[0]);
        Assert.equals(item.unit, cells[0].units.elementAt(counter));

        counter++;
      }

      Assert.equals(counter, 0);
    });

    test('2 cell with one unit - the first one is excluded', () {
      // Arrange
      final unit1 = Unit.byType(UnitType.infantry);
      final unit2 = Unit.byType(UnitType.infantry);

      final cells = [
        GameFieldCell(
          terrain: CellTerrain.plain,
          hasRiver: false,
          hasRoad: false,
          center: Vector2.zero(),
          row: 0,
          col: 0,
        )
          ..addUnit(unit1)
          ..setNation(Nation.usa),
        GameFieldCell(
          terrain: CellTerrain.plain,
          hasRiver: false,
          hasRoad: false,
          center: Vector2.zero(),
          row: 0,
          col: 1,
        )
          ..addUnit(unit2)
          ..setNation(Nation.usa),
      ];

      final mockGameField = MockGameFieldRead();
      when(mockGameField.cells).thenReturn(cells);

      // Act
      final iterator = StableUnitsIterator(
        gameField: mockGameField,
        myNation: Nation.usa,
        excludedUnits: [unit1],
        shifted: true,
      );

      // Assert
      Assert.isTrue(iterator.moveNext());
      Assert.equals(iterator.current.cell, cells[1]);
      Assert.equals(iterator.current.unit, unit2);

      Assert.isFalse(iterator.moveNext());
    });

    test('2 cell with one unit - the last one is excluded', () {
      // Arrange
      final unit1 = Unit.byType(UnitType.infantry);
      final unit2 = Unit.byType(UnitType.infantry);

      final cells = [
        GameFieldCell(
          terrain: CellTerrain.plain,
          hasRiver: false,
          hasRoad: false,
          center: Vector2.zero(),
          row: 0,
          col: 0,
        )
          ..addUnit(unit1)
          ..setNation(Nation.usa),
        GameFieldCell(
          terrain: CellTerrain.plain,
          hasRiver: false,
          hasRoad: false,
          center: Vector2.zero(),
          row: 0,
          col: 1,
        )
          ..addUnit(unit2)
          ..setNation(Nation.usa),
      ];

      final mockGameField = MockGameFieldRead();
      when(mockGameField.cells).thenReturn(cells);

      // Act
      final iterator = StableUnitsIterator(
        gameField: mockGameField,
        myNation: Nation.usa,
        excludedUnits: [unit2],
        shifted: true,
      );

      // Assert
      Assert.isTrue(iterator.moveNext());
      Assert.equals(iterator.current.cell, cells[0]);
      Assert.equals(iterator.current.unit, unit1);

      Assert.isFalse(iterator.moveNext());
    });

    test('2 cell with one unit - both are excluded', () {
      // Arrange
      final unit1 = Unit.byType(UnitType.infantry);
      final unit2 = Unit.byType(UnitType.infantry);

      final cells = [
        GameFieldCell(
          terrain: CellTerrain.plain,
          hasRiver: false,
          hasRoad: false,
          center: Vector2.zero(),
          row: 0,
          col: 0,
        )
          ..addUnit(unit1)
          ..setNation(Nation.usa),
        GameFieldCell(
          terrain: CellTerrain.plain,
          hasRiver: false,
          hasRoad: false,
          center: Vector2.zero(),
          row: 0,
          col: 1,
        )
          ..addUnit(unit2)
          ..setNation(Nation.usa),
      ];

      final mockGameField = MockGameFieldRead();
      when(mockGameField.cells).thenReturn(cells);

      // Act
      final iterator = StableUnitsIterator(
        gameField: mockGameField,
        myNation: Nation.usa,
        excludedUnits: [unit1, unit2],
        shifted: true,
      );

      // Assert
      Assert.isFalse(iterator.moveNext());
    });
  });
}
