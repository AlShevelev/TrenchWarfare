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


  static const unitBaseCostCurrency = 15;
  static const unitBaseCostIndustryPoints = 1;
  static const unitExpenseFactor = 2.0;

  static final cityBuildCost = MoneyUnit(currency: 200, industryPoints: 0);
  static final factoryBuildCost = MoneyUnit(currency: 300, industryPoints: 0);
  static final airFieldBuildCost = MoneyUnit(currency: 100, industryPoints: 0);
  static final navalBaseBuildCost = MoneyUnit(currency: 250, industryPoints: 0);

  static final cityIncome = MoneyUnit(currency: 20, industryPoints: 0);
  static final factoryIncome = MoneyUnit(currency: 0, industryPoints: 20);
  static final airFieldIncome = MoneyUnit(currency: 0, industryPoints: 0);
  static final navalBaseIncome = MoneyUnit(currency: 10, industryPoints: 10);

  static final antiAirGunBuildCost = MoneyUnit(currency: 20, industryPoints: 10);
  static final barbedWireBuildCost = MoneyUnit(currency: 10, industryPoints: 1);
  static final landFortBuildCost = MoneyUnit(currency: 50, industryPoints: 15);
  static final landMineBuildCost = MoneyUnit(currency: 10, industryPoints: 2);
  static final seaMineBuildCost = MoneyUnit(currency: 10, industryPoints: 2);
  static final trenchBuildCost = MoneyUnit(currency: 10, industryPoints: 0);

  static final attackBoosterBuildCost = MoneyUnit(currency: 5, industryPoints: 1);
  static final defenceBoosterBuildCost = MoneyUnit(currency: 5, industryPoints: 1);
  static final commanderBoosterBuildCost = MoneyUnit(currency: 40, industryPoints: 0);
  static final transportBoosterBuildCost = MoneyUnit(currency: 20, industryPoints: 5);

  static final gasAttackCost = MoneyUnit(currency: 80, industryPoints: 20);
  static final flechettesCost = MoneyUnit(currency: 120, industryPoints: 10);
  static final airBombardmentCost = MoneyUnit(currency: 250, industryPoints: 100);
  static final flameTroopersCost = MoneyUnit(currency: 15, industryPoints: 5);
  static final propagandaCost = MoneyUnit(currency: 30, industryPoints: 0);
}