part of game_field_sm;

class FromReadyForInputOnCardsButtonClick {
  late final MoneyUnit _nationMoney;

  late final SimpleStream<GameFieldControlsState> _controlsState;

  late final GameFieldRead _gameField;

  late final Nation _myNation;

  late final MapMetadataRead _mapMetadata;

  FromReadyForInputOnCardsButtonClick(
    this._nationMoney,
    this._controlsState,
    this._gameField,
    this._myNation,
    this._mapMetadata,
  );

  State process() {
    final unitBuildCalculator = UnitBuildCalculator(_gameField, _myNation);
    final terrainModifiersBuildCalculator = TerrainModifierBuildCalculator(_gameField, _myNation);
    final unitBoosterBuildCalculator = UnitBoosterBuildCalculator(_gameField, _myNation);
    final specialStrikesBuildCalculator = SpecialStrikesBuildCalculator(_gameField, _myNation, _mapMetadata);
    final productionCentersBuildCalculator = ProductionCentersBuildCalculator(_gameField, _myNation);

    final cards = CardsSelectionControls(
      totalMoney: _nationMoney,
      units: [
        _mapUnit(Unit.byType(UnitType.infantry), unitBuildCalculator),
        _mapUnit(Unit.byType(UnitType.cavalry), unitBuildCalculator),
        _mapUnit(Unit.byType(UnitType.machineGuns), unitBuildCalculator),
        _mapUnit(Unit.byType(UnitType.artillery), unitBuildCalculator),
        _mapUnit(Unit.byType(UnitType.machineGunnersCart), unitBuildCalculator),
        _mapUnit(Unit.byType(UnitType.armoredCar), unitBuildCalculator),
        _mapUnit(Unit.byType(UnitType.tank), unitBuildCalculator),
        _mapUnit(Carrier.create(), unitBuildCalculator),
        _mapUnit(Unit.byType(UnitType.destroyer), unitBuildCalculator),
        _mapUnit(Unit.byType(UnitType.cruiser), unitBuildCalculator),
        _mapUnit(Unit.byType(UnitType.battleship), unitBuildCalculator),
      ],
      productionCenters: [
        _mapProductionCenter(ProductionCenterType.city, productionCentersBuildCalculator),
        _mapProductionCenter(ProductionCenterType.factory, productionCentersBuildCalculator),
        _mapProductionCenter(ProductionCenterType.airField, productionCentersBuildCalculator),
        _mapProductionCenter(ProductionCenterType.navalBase, productionCentersBuildCalculator),
      ],
      terrainModifiers: [
        _mapTerrainModifier(TerrainModifierType.trench, terrainModifiersBuildCalculator),
        _mapTerrainModifier(TerrainModifierType.barbedWire, terrainModifiersBuildCalculator),
        _mapTerrainModifier(TerrainModifierType.landFort, terrainModifiersBuildCalculator),
        _mapTerrainModifier(TerrainModifierType.landMine, terrainModifiersBuildCalculator),
        _mapTerrainModifier(TerrainModifierType.antiAirGun, terrainModifiersBuildCalculator),
        _mapTerrainModifier(TerrainModifierType.seaMine, terrainModifiersBuildCalculator),
      ],
      unitBoosters: [
        _mapUnitBooster(UnitBoost.attack, unitBoosterBuildCalculator),
        _mapUnitBooster(UnitBoost.defence, unitBoosterBuildCalculator),
        _mapUnitBooster(UnitBoost.transport, unitBoosterBuildCalculator),
        _mapUnitBooster(UnitBoost.commander, unitBoosterBuildCalculator),
      ],
      specialStrikes: [
        _mapSpecialStrikes(SpecialStrikeType.gasAttack, specialStrikesBuildCalculator),
        _mapSpecialStrikes(SpecialStrikeType.flameTroopers, specialStrikesBuildCalculator),
        _mapSpecialStrikes(SpecialStrikeType.flechettes, specialStrikesBuildCalculator),
        _mapSpecialStrikes(SpecialStrikeType.airBombardment, specialStrikesBuildCalculator),
        _mapSpecialStrikes(SpecialStrikeType.propaganda, specialStrikesBuildCalculator),
      ],
    );

    _controlsState.update(cards);

    return CardSelecting();
  }

  GameFieldControlsUnitCard _mapUnit(Unit unit, UnitBuildCalculator buildCalculator) {
    final cost = MoneyUnitsCalculator.calculateProductionCost(unit.type);

    final canBuildOnGameField = buildCalculator.canBuildOnGameField(unit.type);

    return GameFieldControlsUnitCard(
      cost: cost,
      type: unit.type,
      maxHealth: unit.maxHealth.toInt(),
      attack: unit.attack.toInt(),
      defence: unit.defence.toInt(),
      damage: Range<int>(unit.damage.min.toInt(), unit.damage.max.toInt()),
      movementPoints: unit.maxMovementPoints,
      canBuildByCurrency: _nationMoney.currency >= cost.currency,
      canBuildByIndustryPoint: _nationMoney.industryPoints >= cost.industryPoints,
      buildDisplayRestriction: canBuildOnGameField ? buildCalculator.getRestriction(unit.type) : null,
      buildError: canBuildOnGameField ? null : buildCalculator.getError(unit.type),
    );
  }

  GameFieldControlsTerrainModifiersCard _mapTerrainModifier(
    TerrainModifierType type,
    TerrainModifierBuildCalculator buildCalculator,
  ) {
    final allCells = buildCalculator.getAllCellsToBuild(type);

    int minCurrency = 1000000;
    int minIndustryPoints = 1000000;

    for (var cell in allCells) {
      final cost = MoneyTerrainModifierCalculator.calculateBuildCost(cell.terrain, type)!;
      if (cost.currency < minCurrency) {
        minCurrency = cost.currency;
      }

      if (cost.industryPoints < minIndustryPoints) {
        minIndustryPoints = cost.industryPoints;
      }
    }

    final cost = allCells.isEmpty
        ? MoneyTerrainModifierCalculator.calculateBuildCost(CellTerrain.plain, type)!
        : MoneyUnit(currency: minCurrency, industryPoints: minIndustryPoints);

    return GameFieldControlsTerrainModifiersCard(
      cost: cost,
      type: type,
      canBuildByCurrency: _nationMoney.currency >= cost.currency,
      canBuildByIndustryPoint: _nationMoney.industryPoints >= cost.industryPoints,
      buildDisplayRestriction: null,
      buildError: allCells.isEmpty ? buildCalculator.getError() : null,
    );
  }

  GameFieldControlsUnitBoostersCard _mapUnitBooster(UnitBoost boost, UnitBoosterBuildCalculator buildCalculator) {
    final cost = MoneyUnitBoostCalculator.calculateCost(boost);

    return GameFieldControlsUnitBoostersCard(
      cost: cost,
      type: boost,
      canBuildByCurrency: _nationMoney.currency >= cost.currency,
      canBuildByIndustryPoint: _nationMoney.industryPoints >= cost.industryPoints,
      buildDisplayRestriction: null,
      buildError: buildCalculator.canBuildOnGameField(boost) ? null : buildCalculator.getError(),
    );
  }

  GameFieldControlsSpecialStrikesCard _mapSpecialStrikes(SpecialStrikeType type, SpecialStrikesBuildCalculator buildCalculator) {
    final cost = MoneySpecialStrikeCalculator.calculateCost(type);

    final canBuildOnGameField = buildCalculator.canBuildOnGameField(type);

    return GameFieldControlsSpecialStrikesCard(
      cost: cost,
      type: type,
      canBuildByCurrency: _nationMoney.currency >= cost.currency,
      canBuildByIndustryPoint: _nationMoney.industryPoints >= cost.industryPoints,
      buildDisplayRestriction: canBuildOnGameField ? buildCalculator.getDisplayRestriction(type) : null,
      buildError: canBuildOnGameField ? null : buildCalculator.getError(type),
    );
  }

  GameFieldControlsProductionCentersCard _mapProductionCenter(
    ProductionCenterType type,
    ProductionCentersBuildCalculator buildCalculator,
  ) {
    final allCells = buildCalculator.getAllCellsToBuild(type);

    int minCurrency = 1000000;
    int minIndustryPoints = 1000000;

    for (var cell in allCells) {
      final cost = MoneyProductionCenterCalculator.calculateBuildCost(
        cell.terrain,
        type,
        cell.productionCenter?.nextLevel ?? ProductionCenterLevel.level1,
      )!;
      if (cost.currency < minCurrency) {
        minCurrency = cost.currency;
      }

      if (cost.industryPoints < minIndustryPoints) {
        minIndustryPoints = cost.industryPoints;
      }
    }

    final cost = allCells.isEmpty
        ? MoneyProductionCenterCalculator.calculateBuildCost(
            type == ProductionCenterType.navalBase ? CellTerrain.water : CellTerrain.plain,
            type,
            ProductionCenterLevel.level1,
          )!
        : MoneyUnit(currency: minCurrency, industryPoints: minIndustryPoints);

    return GameFieldControlsProductionCentersCard(
      cost: cost,
      type: type,
      canBuildByCurrency: _nationMoney.currency >= cost.currency,
      canBuildByIndustryPoint: _nationMoney.industryPoints >= cost.industryPoints,
      buildDisplayRestriction: null,
      buildError: allCells.isEmpty ? buildCalculator.getError() : null,
    );
  }
}
