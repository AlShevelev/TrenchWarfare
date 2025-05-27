/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of battle;

class BattleResult {
  final UnitBattleResult attackingUnit;
  final UnitBattleResult defendingUnit;

  /// The value is null if the attacking unit is dead
  final int? attackingUnitCellId;

  /// The value is null if the defending unit is dead
  final int? defendingUnitCellId;

  final bool isDefendingCellTerrainModifierDestroyed;

  // The value is null if the defending cell hasn't got a production center or the defending cell is not captured
  final ProductionCenterLevel? defendingCellProductionCenterNewLevel;

  @override
  String toString() => 'BATTLE_RESULT: {attackingUnit: $attackingUnit; defendingUnit: $defendingUnit; '
      'attackingUnitCellId: $attackingUnitCellId; defendingUnitCellId: $defendingUnitCellId; '
      'isDefendingCellTerrainModifierDestroyed: $isDefendingCellTerrainModifierDestroyed; '
      'defendingCellProductionCenterNewLevel: $defendingCellProductionCenterNewLevel}';

  BattleResult({
    required this.attackingUnit,
    required this.defendingUnit,
    required this.attackingUnitCellId,
    required this.defendingUnitCellId,
    required this.isDefendingCellTerrainModifierDestroyed,
    required this.defendingCellProductionCenterNewLevel,
  });
}
