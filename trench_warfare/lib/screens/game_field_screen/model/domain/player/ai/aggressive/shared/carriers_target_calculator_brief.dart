/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of aggressive_ai_shared_library;

class CarriersTargetCalculatorBrief {
  final GameFieldRead _gameField;

  final Nation _myNation;

  final MapMetadataRead _metadata;

  CarriersTargetCalculatorBrief({
    required GameFieldRead gameField,
    required Nation myNation,
    required MapMetadataRead metadata,
  })  : _gameField = gameField,
        _myNation = myNation,
        _metadata = metadata;

  GameFieldCellRead? getTarget(GameFieldCellRead carrierCell) {
    final myEnemies = _metadata.getEnemies(_myNation);

    final allEnemyPcCells = <GameFieldCellRead>[];

    // Collects all enemy PCs
    for (final cell in _gameField.cells) {
      if (cell.productionCenter?.type == ProductionCenterType.city ||
          cell.productionCenter?.type == ProductionCenterType.factory) {
        if (myEnemies.contains(cell.nation)) {
          allEnemyPcCells.add(cell);
        }
      }
    }

    final distances = <double>[];

    // Calculates the distances weights between an enemy PC and the carrier
    for (final enemyPcCell in allEnemyPcCells) {
      distances.add(10.0 / _gameField.calculateDistance(carrierCell, enemyPcCell));
    }

    final selectedIndex = RandomGen.randomWeight(distances);

    if (selectedIndex == null) {
      return null;
    }

    return allEnemyPcCells[selectedIndex];
  }
}
