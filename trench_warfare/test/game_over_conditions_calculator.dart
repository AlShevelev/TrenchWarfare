import 'package:flame/components.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:trench_warfare/core/entities/game_objects/game_object_library.dart';
import 'package:trench_warfare/core/enums/cell_terrain.dart';
import 'package:trench_warfare/core/enums/nation.dart';
import 'package:trench_warfare/core/enums/production_center_level.dart';
import 'package:trench_warfare/core/enums/production_center_type.dart';
import 'package:trench_warfare/screens/game_field_screen/model/data/readers/metadata/dto/map_metadata.dart';
import 'package:trench_warfare/core/entities/game_field/game_field_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/victory/game_over_conditions_calculator.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/victory/game_over_conditions.dart';

import 'assert.dart';

import 'game_over_conditions_calculator.mocks.dart';

@GenerateMocks([GameFieldRead])
@GenerateMocks([MapMetadataRead])
void main() {
  group('GameOverConditionsCalculator', () {
    test('Game field is empty', () {
      // Arrange
      const nation = Nation.usa;

      final cells = <GameFieldCell>[];

      final mockGameField = MockGameFieldRead();
      when(mockGameField.cells).thenReturn(cells);

      final mockMetadata = MockMapMetadataRead();
      when(mockMetadata.getMyEnemies(nation)).thenReturn([]);
      when(mockMetadata.getAlliedAndNeutral(nation)).thenReturn([]);

      final calculator = GameOverConditionsCalculator(
        gameField: mockGameField,
        metadata: mockMetadata,
        defeated: [],
      );

      // Act
      final result = calculator.calculate(myNation: nation, humanNation: Nation.russia);

      // Assert
      Assert.isNull(result);
    });

    test('Global victory', () {
      // Arrange
      const myNation = Nation.usa;
      const enemy1 = Nation.russia;
      const enemy2 = Nation.romania;
      const peaceful = Nation.italy;

      final cells = <GameFieldCell>[
        // I've got a PC
        GameFieldCell(
          terrain: CellTerrain.plain,
          hasRiver: false,
          hasRoad: false,
          center: Vector2.zero(),
          row: 0,
          col: 0,
        )
          ..setNation(myNation)
          ..setProductionCenter(ProductionCenter(
            type: ProductionCenterType.city,
            level: ProductionCenterLevel.level1,
            name: {},
          )),
        // But my enemy hasn't
        GameFieldCell(
          terrain: CellTerrain.plain,
          hasRiver: false,
          hasRoad: false,
          center: Vector2.zero(),
          row: 0,
          col: 0,
        )..setNation(enemy1),
        // As well as this one
        GameFieldCell(
          terrain: CellTerrain.plain,
          hasRiver: false,
          hasRoad: false,
          center: Vector2.zero(),
          row: 0,
          col: 0,
        )..setNation(enemy2),
        // And this one
        GameFieldCell(
          terrain: CellTerrain.plain,
          hasRiver: false,
          hasRoad: false,
          center: Vector2.zero(),
          row: 0,
          col: 0,
        )..setNation(peaceful),
        GameFieldCell(
          terrain: CellTerrain.plain,
          hasRiver: false,
          hasRoad: false,
          center: Vector2.zero(),
          row: 0,
          col: 0,
        )..setNation(myNation),
        // My enemy has an Air field, but it's not included in win/lose conditions
        GameFieldCell(
          terrain: CellTerrain.plain,
          hasRiver: false,
          hasRoad: false,
          center: Vector2.zero(),
          row: 0,
          col: 0,
        )
          ..setNation(enemy1)
          ..setProductionCenter(ProductionCenter(
            type: ProductionCenterType.airField,
            level: ProductionCenterLevel.level1,
            name: {},
          )),
        // This one has an Air field as well
        GameFieldCell(
          terrain: CellTerrain.plain,
          hasRiver: false,
          hasRoad: false,
          center: Vector2.zero(),
          row: 0,
          col: 0,
        )
          ..setNation(enemy2)
          ..setProductionCenter(ProductionCenter(
            type: ProductionCenterType.airField,
            level: ProductionCenterLevel.level1,
            name: {},
          )),
        // And this one
        GameFieldCell(
          terrain: CellTerrain.plain,
          hasRiver: false,
          hasRoad: false,
          center: Vector2.zero(),
          row: 0,
          col: 0,
        )..setNation(peaceful),
        GameFieldCell(
          terrain: CellTerrain.water,
          hasRiver: false,
          hasRoad: false,
          center: Vector2.zero(),
          row: 0,
          col: 0,
        )..setNation(myNation),
        // My enemy has a Naval base, but it's not included in win/lose conditions
        GameFieldCell(
          terrain: CellTerrain.water,
          hasRiver: false,
          hasRoad: false,
          center: Vector2.zero(),
          row: 0,
          col: 0,
        )
          ..setNation(enemy1)
          ..setProductionCenter(ProductionCenter(
            type: ProductionCenterType.navalBase,
            level: ProductionCenterLevel.level1,
            name: {},
          )),
        // This one has a Naval base as well
        GameFieldCell(
          terrain: CellTerrain.water,
          hasRiver: false,
          hasRoad: false,
          center: Vector2.zero(),
          row: 0,
          col: 0,
        )
          ..setNation(enemy2)
          ..setProductionCenter(ProductionCenter(
            type: ProductionCenterType.navalBase,
            level: ProductionCenterLevel.level1,
            name: {},
          )),
        GameFieldCell(
          terrain: CellTerrain.water,
          hasRiver: false,
          hasRoad: false,
          center: Vector2.zero(),
          row: 0,
          col: 0,
        )..setNation(peaceful),
      ];

      final mockGameField = MockGameFieldRead();
      when(mockGameField.cells).thenReturn(cells);

      final mockMetadata = MockMapMetadataRead();
      when(mockMetadata.getAll()).thenReturn([myNation, enemy1, enemy2, peaceful]);
      when(mockMetadata.getMyEnemies(myNation)).thenReturn([enemy1, enemy2]);
      when(mockMetadata.getAlliedAndNeutral(myNation)).thenReturn([peaceful]);

      final calculator = GameOverConditionsCalculator(
        gameField: mockGameField,
        metadata: mockMetadata,
        defeated: [],
      );

      // Act
      final result = calculator.calculate(myNation: myNation, humanNation: enemy1);

      // Assert
      Assert.isNotNull(result);
      Assert.isTrue(result is GlobalVictory);
    });

    test('Defeat for non-aggressive nation', () {
      // Arrange
      const myNation = Nation.usa;
      const enemy = Nation.russia;
      const peaceful = Nation.italy;

      final cells = <GameFieldCell>[
        // I've got a PC
        GameFieldCell(
          terrain: CellTerrain.plain,
          hasRiver: false,
          hasRoad: false,
          center: Vector2.zero(),
          row: 0,
          col: 0,
        )
          ..setNation(myNation)
          ..setProductionCenter(ProductionCenter(
            type: ProductionCenterType.city,
            level: ProductionCenterLevel.level1,
            name: {},
          )),
        // And my enemy as well
        GameFieldCell(
          terrain: CellTerrain.plain,
          hasRiver: false,
          hasRoad: false,
          center: Vector2.zero(),
          row: 0,
          col: 0,
        )
          ..setNation(enemy)
          ..setProductionCenter(ProductionCenter(
            type: ProductionCenterType.city,
            level: ProductionCenterLevel.level1,
            name: {},
          )),
        // But this one - hasn't
        GameFieldCell(
          terrain: CellTerrain.plain,
          hasRiver: false,
          hasRoad: false,
          center: Vector2.zero(),
          row: 0,
          col: 0,
        )..setNation(peaceful),
        GameFieldCell(
          terrain: CellTerrain.plain,
          hasRiver: false,
          hasRoad: false,
          center: Vector2.zero(),
          row: 0,
          col: 0,
        )..setNation(myNation),
        // My enemy has an Air field, but it's not included in win/lose conditions
        GameFieldCell(
          terrain: CellTerrain.plain,
          hasRiver: false,
          hasRoad: false,
          center: Vector2.zero(),
          row: 0,
          col: 0,
        )
          ..setNation(enemy)
          ..setProductionCenter(ProductionCenter(
            type: ProductionCenterType.airField,
            level: ProductionCenterLevel.level1,
            name: {},
          )),
        // As well as this one
        GameFieldCell(
          terrain: CellTerrain.plain,
          hasRiver: false,
          hasRoad: false,
          center: Vector2.zero(),
          row: 0,
          col: 0,
        )
          ..setNation(peaceful)
          ..setProductionCenter(ProductionCenter(
            type: ProductionCenterType.airField,
            level: ProductionCenterLevel.level1,
            name: {},
          )),
        GameFieldCell(
          terrain: CellTerrain.water,
          hasRiver: false,
          hasRoad: false,
          center: Vector2.zero(),
          row: 0,
          col: 0,
        )..setNation(myNation),
        // My enemy has a Naval base, but it's not included in win/lose conditions
        GameFieldCell(
          terrain: CellTerrain.water,
          hasRiver: false,
          hasRoad: false,
          center: Vector2.zero(),
          row: 0,
          col: 0,
        )
          ..setNation(enemy)
          ..setProductionCenter(ProductionCenter(
            type: ProductionCenterType.navalBase,
            level: ProductionCenterLevel.level1,
            name: {},
          )),
        // As well as this one
        GameFieldCell(
          terrain: CellTerrain.water,
          hasRiver: false,
          hasRoad: false,
          center: Vector2.zero(),
          row: 0,
          col: 0,
        )
          ..setNation(peaceful)
          ..setProductionCenter(ProductionCenter(
            type: ProductionCenterType.navalBase,
            level: ProductionCenterLevel.level1,
            name: {},
          )),
      ];

      final mockGameField = MockGameFieldRead();
      when(mockGameField.cells).thenReturn(cells);

      final mockMetadata = MockMapMetadataRead();
      when(mockMetadata.getAll()).thenReturn([myNation, enemy, peaceful]);
      when(mockMetadata.getMyEnemies(myNation)).thenReturn([enemy]);
      when(mockMetadata.getAlliedAndNeutral(myNation)).thenReturn([peaceful]);

      final calculator = GameOverConditionsCalculator(
        gameField: mockGameField,
        metadata: mockMetadata,
        defeated: [],
      );

      // Act
      final result = calculator.calculate(myNation: myNation, humanNation: enemy);

      // Assert
      Assert.isNotNull(result);
      Assert.isTrue(result is Defeat);
      Assert.equals((result as Defeat).nation, peaceful);
    });

    test('Defeat for aggressive nation', () {
      // Arrange
      const myNation = Nation.usa;
      const enemy1 = Nation.russia;
      const enemy2 = Nation.romania;
      const peaceful = Nation.italy;

      final cells = <GameFieldCell>[
        // I've got a PC
        GameFieldCell(
          terrain: CellTerrain.plain,
          hasRiver: false,
          hasRoad: false,
          center: Vector2.zero(),
          row: 0,
          col: 0,
        )
          ..setNation(myNation)
          ..setProductionCenter(ProductionCenter(
            type: ProductionCenterType.city,
            level: ProductionCenterLevel.level1,
            name: {},
          )),
        // But my enemy hasn't
        GameFieldCell(
          terrain: CellTerrain.plain,
          hasRiver: false,
          hasRoad: false,
          center: Vector2.zero(),
          row: 0,
          col: 0,
        )
          ..setNation(enemy1)
          ..setProductionCenter(ProductionCenter(
            type: ProductionCenterType.city,
            level: ProductionCenterLevel.level1,
            name: {},
          )),
        // As well as this one
        GameFieldCell(
          terrain: CellTerrain.plain,
          hasRiver: false,
          hasRoad: false,
          center: Vector2.zero(),
          row: 0,
          col: 0,
        )
          ..setNation(myNation)
          ..setProductionCenter(ProductionCenter(
            type: ProductionCenterType.city,
            level: ProductionCenterLevel.level1,
            name: {},
          )),
        // And this one
        GameFieldCell(
          terrain: CellTerrain.plain,
          hasRiver: false,
          hasRoad: false,
          center: Vector2.zero(),
          row: 0,
          col: 0,
        )
          ..setNation(peaceful)
          ..setProductionCenter(ProductionCenter(
            type: ProductionCenterType.city,
            level: ProductionCenterLevel.level1,
            name: {},
          )),
      ];

      final mockGameField = MockGameFieldRead();
      when(mockGameField.cells).thenReturn(cells);

      final mockMetadata = MockMapMetadataRead();
      when(mockMetadata.getAll()).thenReturn([myNation, enemy1, enemy2, peaceful]);
      when(mockMetadata.getMyEnemies(myNation)).thenReturn([enemy1, enemy2]);
      when(mockMetadata.getAlliedAndNeutral(myNation)).thenReturn([peaceful]);

      final calculator = GameOverConditionsCalculator(
        gameField: mockGameField,
        metadata: mockMetadata,
        defeated: [],
      );

      // Act
      final result = calculator.calculate(myNation: myNation, humanNation: enemy1);

      // Assert
      Assert.isNotNull(result);
      Assert.isTrue(result is Defeat);
      Assert.equals((result as Defeat).nation, enemy2);
    });

    test('Defeat is not returned for a second time', () {
      // Arrange
      const myNation = Nation.usa;
      const enemy = Nation.russia;
      const peaceful = Nation.italy;

      final cells = <GameFieldCell>[
        // I've got a PC
        GameFieldCell(
          terrain: CellTerrain.plain,
          hasRiver: false,
          hasRoad: false,
          center: Vector2.zero(),
          row: 0,
          col: 0,
        )
          ..setNation(myNation)
          ..setProductionCenter(ProductionCenter(
            type: ProductionCenterType.city,
            level: ProductionCenterLevel.level1,
            name: {},
          )),
        // And my enemy as well
        GameFieldCell(
          terrain: CellTerrain.plain,
          hasRiver: false,
          hasRoad: false,
          center: Vector2.zero(),
          row: 0,
          col: 0,
        )
          ..setNation(enemy)
          ..setProductionCenter(ProductionCenter(
            type: ProductionCenterType.city,
            level: ProductionCenterLevel.level1,
            name: {},
          )),
        // But this one - hasn't
        GameFieldCell(
          terrain: CellTerrain.plain,
          hasRiver: false,
          hasRoad: false,
          center: Vector2.zero(),
          row: 0,
          col: 0,
        )..setNation(peaceful),
        GameFieldCell(
          terrain: CellTerrain.plain,
          hasRiver: false,
          hasRoad: false,
          center: Vector2.zero(),
          row: 0,
          col: 0,
        )..setNation(myNation),
        // My enemy has an Air field, but it's not included in win/lose conditions
        GameFieldCell(
          terrain: CellTerrain.plain,
          hasRiver: false,
          hasRoad: false,
          center: Vector2.zero(),
          row: 0,
          col: 0,
        )
          ..setNation(enemy)
          ..setProductionCenter(ProductionCenter(
            type: ProductionCenterType.airField,
            level: ProductionCenterLevel.level1,
            name: {},
          )),
        // As well as this one
        GameFieldCell(
          terrain: CellTerrain.plain,
          hasRiver: false,
          hasRoad: false,
          center: Vector2.zero(),
          row: 0,
          col: 0,
        )
          ..setNation(peaceful)
          ..setProductionCenter(ProductionCenter(
            type: ProductionCenterType.airField,
            level: ProductionCenterLevel.level1,
            name: {},
          )),
        GameFieldCell(
          terrain: CellTerrain.water,
          hasRiver: false,
          hasRoad: false,
          center: Vector2.zero(),
          row: 0,
          col: 0,
        )..setNation(myNation),
        // My enemy has a Naval base, but it's not included in win/lose conditions
        GameFieldCell(
          terrain: CellTerrain.water,
          hasRiver: false,
          hasRoad: false,
          center: Vector2.zero(),
          row: 0,
          col: 0,
        )
          ..setNation(enemy)
          ..setProductionCenter(ProductionCenter(
            type: ProductionCenterType.navalBase,
            level: ProductionCenterLevel.level1,
            name: {},
          )),
        // As well as this one
        GameFieldCell(
          terrain: CellTerrain.water,
          hasRiver: false,
          hasRoad: false,
          center: Vector2.zero(),
          row: 0,
          col: 0,
        )
          ..setNation(peaceful)
          ..setProductionCenter(ProductionCenter(
            type: ProductionCenterType.navalBase,
            level: ProductionCenterLevel.level1,
            name: {},
          )),
      ];

      final mockGameField = MockGameFieldRead();
      when(mockGameField.cells).thenReturn(cells);

      final mockMetadata = MockMapMetadataRead();
      when(mockMetadata.getAll()).thenReturn([myNation, enemy, peaceful]);
      when(mockMetadata.getMyEnemies(myNation)).thenReturn([enemy]);
      when(mockMetadata.getAlliedAndNeutral(myNation)).thenReturn([peaceful]);

      final calculator = GameOverConditionsCalculator(
        gameField: mockGameField,
        metadata: mockMetadata,
        defeated: [],
      );

      // Act
      calculator.calculate(myNation: myNation, humanNation: enemy);
      final result = calculator.calculate(myNation: myNation, humanNation: enemy);

      // Assert
      Assert.isNull(result);
    });

    test('Without events', () {
      // Arrange
      const myNation = Nation.usa;
      const enemy = Nation.russia;
      const peaceful = Nation.italy;

      final cells = <GameFieldCell>[
        // I've got a PC
        GameFieldCell(
          terrain: CellTerrain.plain,
          hasRiver: false,
          hasRoad: false,
          center: Vector2.zero(),
          row: 0,
          col: 0,
        )
          ..setNation(myNation)
          ..setProductionCenter(ProductionCenter(
            type: ProductionCenterType.city,
            level: ProductionCenterLevel.level1,
            name: {},
          )),
        // And my enemy as well
        GameFieldCell(
          terrain: CellTerrain.plain,
          hasRiver: false,
          hasRoad: false,
          center: Vector2.zero(),
          row: 0,
          col: 0,
        )
          ..setNation(enemy)
          ..setProductionCenter(ProductionCenter(
            type: ProductionCenterType.city,
            level: ProductionCenterLevel.level1,
            name: {},
          )),
        // And this one
        GameFieldCell(
          terrain: CellTerrain.plain,
          hasRiver: false,
          hasRoad: false,
          center: Vector2.zero(),
          row: 0,
          col: 0,
        )
          ..setNation(peaceful)
          ..setProductionCenter(ProductionCenter(
            type: ProductionCenterType.city,
            level: ProductionCenterLevel.level1,
            name: {},
          )),
      ];

      final mockGameField = MockGameFieldRead();
      when(mockGameField.cells).thenReturn(cells);

      final mockMetadata = MockMapMetadataRead();
      when(mockMetadata.getAll()).thenReturn([myNation, enemy, peaceful]);
      when(mockMetadata.getMyEnemies(myNation)).thenReturn([enemy]);
      when(mockMetadata.getAlliedAndNeutral(myNation)).thenReturn([peaceful]);

      final calculator = GameOverConditionsCalculator(
        gameField: mockGameField,
        metadata: mockMetadata,
        defeated: [],
      );

      // Act
      final result = calculator.calculate(myNation: myNation, humanNation: enemy);

      // Assert
      Assert.isNull(result);
    });
  });
}
