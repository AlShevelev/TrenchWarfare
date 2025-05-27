/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of money_calculators;

class MoneyTerrainModifierCalculator {
  static MoneyUnit? calculateBuildCost(CellTerrain terrain, TerrainModifierType type) => switch (terrain) {
        CellTerrain.plain => _calculateBaseCost(type),
        CellTerrain.wood => switch (type) {
            TerrainModifierType.trench => _calculateBaseCost(type).multiplyBy(1.2),
            _ => null,
          },
        CellTerrain.marsh => switch (type) {
            TerrainModifierType.antiAirGun ||
            TerrainModifierType.landMine =>
              _calculateBaseCost(type).multiplyBy(1.2),
            _ => null,
          },
        CellTerrain.sand => switch (type) {
            TerrainModifierType.antiAirGun ||
            TerrainModifierType.barbedWire =>
              _calculateBaseCost(type).multiplyBy(1.2),
            TerrainModifierType.landMine => _calculateBaseCost(type),
            _ => null,
          },
        CellTerrain.hills => switch (type) {
            TerrainModifierType.antiAirGun ||
            TerrainModifierType.barbedWire ||
            TerrainModifierType.trench =>
              _calculateBaseCost(type),
            TerrainModifierType.landFort => _calculateBaseCost(type).multiplyBy(1.2),
            _ => null,
          },
        CellTerrain.mountains => switch (type) {
            TerrainModifierType.antiAirGun => _calculateBaseCost(type).multiplyBy(1.5),
            TerrainModifierType.landFort => _calculateBaseCost(type).multiplyBy(2),
            _ => null,
          },
        CellTerrain.snow => switch (type) {
            TerrainModifierType.barbedWire ||
            TerrainModifierType.landFort ||
            TerrainModifierType.trench =>
              _calculateBaseCost(type).multiplyBy(1.2),
            TerrainModifierType.antiAirGun => _calculateBaseCost(type).multiplyBy(1.1),
            _ => null,
          },
        CellTerrain.water => switch (type) {
            TerrainModifierType.seaMine => _calculateBaseCost(type),
            _ => null,
          },
      };

  static MoneyUnit _calculateBaseCost(TerrainModifierType type) => switch (type) {
        TerrainModifierType.antiAirGun => _MoneyConstants.antiAirGunBuildCost,
        TerrainModifierType.barbedWire => _MoneyConstants.barbedWireBuildCost,
        TerrainModifierType.landFort => _MoneyConstants.landFortBuildCost,
        TerrainModifierType.landMine => _MoneyConstants.landMineBuildCost,
        TerrainModifierType.seaMine => _MoneyConstants.seaMineBuildCost,
        TerrainModifierType.trench => _MoneyConstants.trenchBuildCost,
      };
}
