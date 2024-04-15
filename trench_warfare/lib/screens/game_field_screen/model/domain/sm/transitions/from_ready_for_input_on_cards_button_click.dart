part of game_field_sm;

class FromReadyForInputOnCardsButtonClick {
  late final MoneyUnit _nationMoney;

  late final SingleStream<GameFieldControlsState> _controlsState;

  late final GameFieldRead _gameField;

  FromReadyForInputOnCardsButtonClick(
    this._nationMoney,
    this._controlsState,
    this._gameField,
  );

  State process() {
    final unitBuildCalculator = UnitBuildCalculator(_gameField);

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
        terrainModifiers: [],
        troopBoosters: [],
        specialStrikes: [],
      ),
    );

    return ReadyForInput();
  }

  GameFieldControlsUnitCard _mapUnit(Unit unit, UnitBuildCalculator buildCalculator) {
    final cost = MoneyTroopsCalculator.getProductionCost(unit.type);
    final restriction = UnitBuildCalculator.getRestriction(unit.type);

    return GameFieldControlsUnitCard(
      cost: MoneyTroopsCalculator.getProductionCost(unit.type),
      type: unit.type,
      maxHealth: unit.maxHealth.toInt(),
      attack: unit.attack.toInt(),
      defence: unit.defence.toInt(),
      damage: Range<int>(unit.damage.min.toInt(), unit.damage.max.toInt()),
      movementPoints: unit.maxMovementPoints,
      buildRestriction: restriction,
      canBuildByCurrency: _nationMoney.currency >= cost.currency,
      canBuildByIndustryPoint: _nationMoney.industryPoints >= cost.industryPoints,
      canBuildOnGameField: buildCalculator.canBuildOnGameField(unit.type),
    );
  }
}
