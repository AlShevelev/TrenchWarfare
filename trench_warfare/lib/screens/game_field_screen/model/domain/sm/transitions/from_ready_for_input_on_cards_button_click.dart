part of game_field_sm;

class FromReadyForInputOnCardsButtonClick {
  late final MoneyUnit _nationMoney;

  late final SingleStream<GameFieldControlsState> _controlsState;

  FromReadyForInputOnCardsButtonClick(
    this._nationMoney,
    this._controlsState,
  );

  State process() {
    _controlsState.update(
      Cards(
        totalMoney: _nationMoney,
        units: [
          _mapUnit(Unit.createEmpty(UnitType.infantry)),
          _mapUnit(Unit.createEmpty(UnitType.cavalry)),
          _mapUnit(Unit.createEmpty(UnitType.machineGuns)),
          _mapUnit(Unit.createEmpty(UnitType.artillery)),
          _mapUnit(Unit.createEmpty(UnitType.machineGunnersCart)),
          _mapUnit(Unit.createEmpty(UnitType.armoredCar)),
          _mapUnit(Unit.createEmpty(UnitType.tank)),
          _mapUnit(Carrier.createEmpty()),
          _mapUnit(Unit.createEmpty(UnitType.destroyer)),
          _mapUnit(Unit.createEmpty(UnitType.cruiser)),
          _mapUnit(Unit.createEmpty(UnitType.battleship)),
        ],
        productionCenters: [],
        terrainModifiers: [],
        troopBoosters: [],
        specialStrikes: [],
      ),
    );

    return ReadyForInput();
  }

  GameFieldControlsUnitCard _mapUnit(Unit unit) => GameFieldControlsUnitCard(
      cost: MoneyTroopsCalculator.getProductionCost(unit.type),
      type: unit.type,
      maxHealth: unit.maxHealth.toInt(),
      attack: unit.attack.toInt(),
      defence: unit.defence.toInt(),
      damage: Range<int>(unit.damage.min.toInt(), unit.damage.max.toInt()),
      movementPoints: unit.maxMovementPoints,
    );
}
