part of money_calculators;

class MoneyTerrainModifierCalculator {
  static const _baseCurrency = 5;
  static const _baseIndustryPoints = 5;

  static MoneyUnit? getBuildCost(CellTerrain terrain, TerrainModifierType type) => switch (terrain) {
        CellTerrain.plain => switch (type) {
            TerrainModifierType.antiAirGun ||
            TerrainModifierType.barbedWire ||
            TerrainModifierType.landFort ||
            TerrainModifierType.landMine ||
            TerrainModifierType.trench =>
              _calculateBaseCost(type),
            _ => null,
          },
        CellTerrain.wood => switch (type) {
            TerrainModifierType.trench => _calculateBaseCost(type).multiplyBy(1.2),
            _ => null,
          },
        CellTerrain.marsh => switch (type) {
            TerrainModifierType.antiAirGun || TerrainModifierType.landMine => _calculateBaseCost(type),
            _ => null,
          }
              ?.multiplyBy(1.2),
        CellTerrain.sand => switch (type) {
            TerrainModifierType.antiAirGun || TerrainModifierType.barbedWire => _calculateBaseCost(type).multiplyBy(1.2),
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
        TerrainModifierType.antiAirGun => MoneyUnit(
            currency: multiplyBy(_baseCurrency, 2),
            industryPoints: multiplyBy(_baseIndustryPoints, 2),
          ),
        TerrainModifierType.barbedWire => MoneyUnit(
            currency: _baseCurrency,
            industryPoints: _baseIndustryPoints,
          ),
        TerrainModifierType.landFort => MoneyUnit(
            currency: multiplyBy(_baseCurrency, 3),
            industryPoints: multiplyBy(_baseIndustryPoints, 3),
          ),
        TerrainModifierType.landMine => MoneyUnit(
            currency: multiplyBy(_baseCurrency, 2),
            industryPoints: multiplyBy(_baseIndustryPoints, 2),
          ),
        TerrainModifierType.seaMine => MoneyUnit(
            currency: multiplyBy(_baseCurrency, 2),
            industryPoints: multiplyBy(_baseIndustryPoints, 2),
          ),
        TerrainModifierType.trench => MoneyUnit(
            currency: _baseCurrency,
            industryPoints: 0,
          ),
      };
}
