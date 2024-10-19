part of money_calculators;

class _MoneyConstants {
  static final cellPlainIncome = MoneyUnit(currency: 2, industryPoints: 0);
  static final cellWoodIncome = MoneyUnit(currency: 1, industryPoints: 0);
  static final cellMarshIncome = MoneyUnit(currency: 0, industryPoints: 0);
  static final cellSandIncome = MoneyUnit(currency: 0, industryPoints: 0);
  static final cellHillsIncome = MoneyUnit(currency: 1, industryPoints: 0);
  static final cellMountainsIncome = MoneyUnit(currency: 0, industryPoints: 0);
  static final cellSnowIncome = MoneyUnit(currency: 0, industryPoints: 0);
  static final cellWaterIncome = MoneyUnit(currency: 1, industryPoints: 0);

  static final unitLandBaseCost = MoneyUnit(currency: 15, industryPoints: 3);
  static final unitSeaBaseCost = MoneyUnit(currency: 20, industryPoints: 5);
  static const unitExpenseFactor = 4.0;

  static final cityBuildCost = MoneyUnit(currency: 1000, industryPoints: 0);
  static final factoryBuildCost = MoneyUnit(currency: 1000, industryPoints: 0);
  static final airFieldBuildCost = MoneyUnit(currency: 500, industryPoints: 0);
  static final navalBaseBuildCost = MoneyUnit(currency: 750, industryPoints: 0);

  static final cityIncome = MoneyUnit(currency: 40, industryPoints: 0);
  static final factoryIncome = MoneyUnit(currency: 0, industryPoints: 40);
  static final airFieldIncome = MoneyUnit(currency: 0, industryPoints: 0);
  static final navalBaseIncome = MoneyUnit(currency: 20, industryPoints: 20);

  static final antiAirGunBuildCost = MoneyUnit(currency: 105, industryPoints: 21);
  static final barbedWireBuildCost = MoneyUnit(currency: 20, industryPoints: 4);
  static final landFortBuildCost = MoneyUnit(currency: 150, industryPoints: 30);
  static final landMineBuildCost = MoneyUnit(currency: 36, industryPoints: 7);
  static final seaMineBuildCost = MoneyUnit(currency: 48, industryPoints: 12);
  static final trenchBuildCost = MoneyUnit(currency: 20, industryPoints: 4);

  static final attackBoosterBuildCost = MoneyUnit(currency: 15, industryPoints: 3);
  static final defenceBoosterBuildCost = MoneyUnit(currency: 15, industryPoints: 3);
  static final commanderBoosterBuildCost = MoneyUnit(currency: 45, industryPoints: 9);
  static final transportBoosterBuildCost = MoneyUnit(currency: 20, industryPoints: 4);

  static final gasAttackCost = MoneyUnit(currency: 90, industryPoints: 18);
  static final flechettesCost = MoneyUnit(currency: 45, industryPoints: 10);
  static final airBombardmentCost = MoneyUnit(currency: 350, industryPoints: 70);
  static final flameTroopersCost = MoneyUnit(currency: 15, industryPoints: 3);
  static final propagandaCost = MoneyUnit(currency: 100, industryPoints: 0);
}