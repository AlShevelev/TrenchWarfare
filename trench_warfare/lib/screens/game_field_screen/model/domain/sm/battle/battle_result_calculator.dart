part of battle;

class BattleResultCalculator {
  late final GameFieldRead _gameField;

  BattleResultCalculator(GameFieldRead gameField) {
    _gameField = gameField;
  }

  BattleResult calculateBattle({
    required GameFieldCell attackingCell,
    required GameFieldCell defendingCell,
    required UnitsBattleResult battleResult,
  }) {
    if (battleResult.attacking is Died && battleResult.defending is Died) {
      return BattleResult(
        attackingUnit: battleResult.attacking,
        defendingUnit: battleResult.defending,
        attackingUnitCellId: null,
        defendingUnitCellId: null,
        isDefendingCellTerrainModifierDestroyed: false,
        isDefendingCellProductionCenterDestroyed: false,
        defendingCellProductionCenterNewLevel: null,
      );
    }

    if (battleResult.attacking is Died && battleResult.defending is Alive) {
      return BattleResult(
        attackingUnit: battleResult.attacking,
        defendingUnit: battleResult.defending,
        attackingUnitCellId: null,
        defendingUnitCellId: defendingCell.id,
        isDefendingCellTerrainModifierDestroyed: false,
        isDefendingCellProductionCenterDestroyed: false,
        defendingCellProductionCenterNewLevel: null,
      );
    }

    if (battleResult.attacking is Died && battleResult.defending is InPanic) {
      final cellIdToWithdraw = _getCellToWithdraw((battleResult.defending as InPanic).info, defendingCell);

      return BattleResult(
        attackingUnit: battleResult.attacking,
        defendingUnit: battleResult.defending,
        attackingUnitCellId: null,
        defendingUnitCellId: cellIdToWithdraw ?? defendingCell.id,
        isDefendingCellTerrainModifierDestroyed: false,
        isDefendingCellProductionCenterDestroyed: false,
        defendingCellProductionCenterNewLevel: null,
      );
    }

    if (battleResult.attacking is Alive && battleResult.defending is Died) {
      final canBeCaptured = _canBeCaptured(defendingCell);

      return BattleResult(
        attackingUnit: battleResult.attacking,
        defendingUnit: battleResult.defending,
        attackingUnitCellId: canBeCaptured ? defendingCell.id : attackingCell.id,
        defendingUnitCellId: null,
        isDefendingCellTerrainModifierDestroyed: canBeCaptured && defendingCell.terrainModifier != null,
        isDefendingCellProductionCenterDestroyed:
            canBeCaptured && defendingCell.productionCenter?.level == ProductionCenterLevel.level1,
        defendingCellProductionCenterNewLevel: canBeCaptured ? _getProductionCenterLevelForCapturedCell(defendingCell) : null,
      );
    }

    if (battleResult.attacking is Alive && battleResult.defending is Alive) {
      return BattleResult(
        attackingUnit: battleResult.attacking,
        defendingUnit: battleResult.defending,
        attackingUnitCellId: attackingCell.id,
        defendingUnitCellId: defendingCell.id,
        isDefendingCellTerrainModifierDestroyed: false,
        isDefendingCellProductionCenterDestroyed: false,
        defendingCellProductionCenterNewLevel: null,
      );
    }

    if (battleResult.attacking is Alive && battleResult.defending is InPanic) {
      final cellIdToWithdraw = _getCellToWithdraw((battleResult.defending as InPanic).info, defendingCell);
      final canBeCaptured = _canBeCaptured(defendingCell);

      final isCaptured = cellIdToWithdraw != null && canBeCaptured;

      return BattleResult(
        attackingUnit: battleResult.attacking,
        defendingUnit: battleResult.defending,
        attackingUnitCellId: isCaptured ? defendingCell.id : attackingCell.id,
        defendingUnitCellId: cellIdToWithdraw ?? defendingCell.id,
        isDefendingCellTerrainModifierDestroyed: isCaptured && defendingCell.terrainModifier != null,
        isDefendingCellProductionCenterDestroyed:
            isCaptured && defendingCell.productionCenter?.level == ProductionCenterLevel.level1,
        defendingCellProductionCenterNewLevel: isCaptured ? _getProductionCenterLevelForCapturedCell(defendingCell) : null,
      );
    }

    throw UnsupportedError('This case is not supported');
  }

  String? _getCellToWithdraw(UnitInBattle unit, GameFieldCell cell) {
    final willTryToWithdraw = switch (unit.experienceRank) {
      UnitExperienceRank.rookies => RandomGen.random(0, 1) >= 0.2,
      UnitExperienceRank.fighters => RandomGen.random(0, 1) >= 0.4,
      UnitExperienceRank.proficients => RandomGen.random(0, 1) >= 0.6,
      UnitExperienceRank.veterans => RandomGen.random(0, 1) >= 0.8,
      UnitExperienceRank.elite => false,
    };

    if (!willTryToWithdraw) {
      return null;
    }

    final allCellsAround = PathFacade.getCellsAround(_gameField, cell);

    return allCellsAround
        .where((c) => c.nation == cell.nation)
        .where((c) => _haveTheSameType(c, cell))
        .where((c) => !_haveMinefield(c))
        .where((c) => c.units.length < GameConstants.maxUnitsInCell)
        .firstOrNull
        ?.id;
  }

  bool _haveTheSameType(GameFieldCell cell1, GameFieldCell cell2) =>
      (cell1.isLand && cell2.isLand) || (!cell1.isLand && !cell2.isLand);

  bool _haveMinefield(GameFieldCell cell) =>
      cell.terrainModifier?.type == TerrainModifierType.landMine || cell.terrainModifier?.type == TerrainModifierType.seaMine;

  bool _canBeCaptured(GameFieldCell cell) => cell.units.length == 1;

  ProductionCenterLevel? _getProductionCenterLevelForCapturedCell(GameFieldCell cell) => switch (cell.productionCenter?.level) {
        null => null,
        ProductionCenterLevel.level1 => null,
        ProductionCenterLevel.level2 => ProductionCenterLevel.level1,
        ProductionCenterLevel.level3 => ProductionCenterLevel.level2,
        ProductionCenterLevel.level4 => ProductionCenterLevel.level3,
        ProductionCenterLevel.capital => ProductionCenterLevel.level4
      };
}
