part of game_field_sm;

class FromReadyForInputOnCardsButtonClick {
  late final MoneyUnit _nationMoney;

  late final SingleStream<GameFieldControlsState> _controlsState;

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

    _controlsState.update(
      Cards(
        totalMoney: _nationMoney,
        units: [
          _mapUnit(Unit.createEmpty(UnitType.infantry), unitBuildCalculator),
          _mapUnit(Unit.createEmpty(UnitType.cavalry), unitBuildCalculator),
          _mapUnit(Unit.createEmpty(UnitType.machineGuns), unitBuildCalculator),
          _mapUnit(Unit.createEmpty(UnitType.artillery), unitBuildCalculator),
          _mapUnit(Unit.createEmpty(UnitType.machineGunnersCart), unitBuildCalculator),
          _mapUnit(Unit.createEmpty(UnitType.armoredCar), unitBuildCalculator),
          _mapUnit(Unit.createEmpty(UnitType.tank), unitBuildCalculator),
          _mapUnit(Carrier.createEmpty(), unitBuildCalculator),
          _mapUnit(Unit.createEmpty(UnitType.destroyer), unitBuildCalculator),
          _mapUnit(Unit.createEmpty(UnitType.cruiser), unitBuildCalculator),
          _mapUnit(Unit.createEmpty(UnitType.battleship), unitBuildCalculator),
        ],
        productionCenters: [],
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
      ),
    );

    return ReadyForInput();
  }

  GameFieldControlsUnitCard _mapUnit(Unit unit, UnitBuildCalculator buildCalculator) {
    final cost = MoneyTroopsCalculator.calculateProductionCost(unit.type);

    return GameFieldControlsUnitCard(
      cost: cost,
      type: unit.type,
      maxHealth: unit.maxHealth.toInt(),
      attack: unit.attack.toInt(),
      defence: unit.defence.toInt(),
      damage: Range<int>(unit.damage.min.toInt(), unit.damage.max.toInt()),
      movementPoints: unit.maxMovementPoints,
      buildRestriction: buildCalculator.getRestriction(unit.type),
      canBuildByCurrency: _nationMoney.currency >= cost.currency,
      canBuildByIndustryPoint: _nationMoney.industryPoints >= cost.industryPoints,
      canBuildOnGameField: buildCalculator.canBuildOnGameField(unit.type),
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
      buildRestriction: buildCalculator.getRestriction(),
      canBuildByCurrency: _nationMoney.currency >= cost.currency,
      canBuildByIndustryPoint: _nationMoney.industryPoints >= cost.industryPoints,
      canBuildOnGameField: allCells.isNotEmpty,
    );
  }

  GameFieldControlsUnitBoostersCard _mapUnitBooster(UnitBoost boost, UnitBoosterBuildCalculator buildCalculator) {
    final cost = MoneyUnitBoostCalculator.calculateCost(boost);

    return GameFieldControlsUnitBoostersCard(
      cost: cost,
      type: boost,
      buildRestriction: buildCalculator.getRestriction(),
      canBuildByCurrency: _nationMoney.currency >= cost.currency,
      canBuildByIndustryPoint: _nationMoney.industryPoints >= cost.industryPoints,
      canBuildOnGameField: buildCalculator.canBuildOnGameField(boost),
    );
  }

  GameFieldControlsSpecialStrikesCard _mapSpecialStrikes(SpecialStrikeType type, SpecialStrikesBuildCalculator buildCalculator) {
    final cost = MoneySpecialStrikeCalculator.calculateCost(type);
    final restriction = buildCalculator.getRestriction(type);

    return GameFieldControlsSpecialStrikesCard(
      cost: cost,
      type: type,
      buildRestriction: restriction,
      canBuildByCurrency: _nationMoney.currency >= cost.currency,
      canBuildByIndustryPoint: _nationMoney.industryPoints >= cost.industryPoints,
      canBuildOnGameField: buildCalculator.canBuildOnGameField(type),
    );
  }
}
