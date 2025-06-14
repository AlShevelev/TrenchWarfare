/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of cards_placing;

class TerrainModifierCardsPlacingStrategy
    extends CardsPlacingStrategy<GameFieldControlsCard<TerrainModifierType>, TerrainModifierType> {
  TerrainModifierCardsPlacingStrategy({
    required super.card,
    required super.cell,
    required super.nationMoney,
    required super.gameField,
    required super.myNation,
  });

  @override
  MoneyUnit calculateProductionCost() =>
      MoneyTerrainModifierCalculator.calculateBuildCost(_cell.terrain, _type)!;

  @override
  List<GameFieldCellRead> getAllCellsImpossibleToBuild() =>
      TerrainModifierBuildCalculator(_gameField, _myNation)
          .getAllCellsImpossibleToBuild(_type, _nationMoney.totalSum);

  @override
  void updateCell() => _cell.setTerrainModifier(TerrainModifier(type: _type));

  @override
  PlaySound? getSoundForUnit() => _type == TerrainModifierType.landMine || _type == TerrainModifierType.seaMine
      ? PlaySound(type: SoundType.dingUniversal)
      : PlaySound(type: SoundType.productionPC);
}
