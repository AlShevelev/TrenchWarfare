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

class _MoneyConstants {
  static final cellPlainIncome = MoneyUnit(currency: 3, industryPoints: 0);
  static final cellWoodIncome = MoneyUnit(currency: 2, industryPoints: 0);
  static final cellMarshIncome = MoneyUnit(currency: 1, industryPoints: 0);
  static final cellSandIncome = MoneyUnit(currency: 1, industryPoints: 0);
  static final cellHillsIncome = MoneyUnit(currency: 2, industryPoints: 0);
  static final cellMountainsIncome = MoneyUnit(currency: 1, industryPoints: 0);
  static final cellSnowIncome = MoneyUnit(currency: 1, industryPoints: 0);
  static final cellWaterIncome = MoneyUnit(currency: 2, industryPoints: 0);

  static final unitLandBaseCost = MoneyUnit(currency: 15, industryPoints: 6);
  static final unitSeaBaseCost = MoneyUnit(currency: 20, industryPoints: 10);
  static const unitExpenseFactor = 4.0;

  static final cityBuildCost = MoneyUnit(currency: 1000, industryPoints: 100);
  static final factoryBuildCost = MoneyUnit(currency: 1000, industryPoints: 250);
  static final airFieldBuildCost = MoneyUnit(currency: 500, industryPoints: 125);
  static final navalBaseBuildCost = MoneyUnit(currency: 750, industryPoints: 200);

  static final cityIncome = MoneyUnit(currency: 50, industryPoints: 15);
  static final factoryIncome = MoneyUnit(currency: 10, industryPoints: 75);
  static final airFieldIncome = MoneyUnit(currency: 0, industryPoints: 0);
  static final navalBaseIncome = MoneyUnit(currency: 30, industryPoints: 45);

  static final antiAirGunBuildCost = MoneyUnit(currency: 105, industryPoints: 42);
  static final barbedWireBuildCost = MoneyUnit(currency: 20, industryPoints: 8);
  static final landFortBuildCost = MoneyUnit(currency: 250, industryPoints: 100);
  static final landMineBuildCost = MoneyUnit(currency: 36, industryPoints: 14);
  static final seaMineBuildCost = MoneyUnit(currency: 48, industryPoints: 24);
  static final trenchBuildCost = MoneyUnit(currency: 20, industryPoints: 8);

  static final attackBoosterBuildCost = MoneyUnit(currency: 15, industryPoints: 6);
  static final defenceBoosterBuildCost = MoneyUnit(currency: 15, industryPoints: 6);
  static final commanderBoosterBuildCost = MoneyUnit(currency: 45, industryPoints: 18);
  static final transportBoosterBuildCost = MoneyUnit(currency: 20, industryPoints: 8);

  static final gasAttackCost = MoneyUnit(currency: 180, industryPoints: 72);
  static final flechettesCost = MoneyUnit(currency: 90, industryPoints: 40);
  static final airBombardmentCost = MoneyUnit(currency: 350, industryPoints: 140);
  static final flameTroopersCost = MoneyUnit(currency: 60, industryPoints: 24);
  static final propagandaCost = MoneyUnit(currency: 100, industryPoints: 0);
}