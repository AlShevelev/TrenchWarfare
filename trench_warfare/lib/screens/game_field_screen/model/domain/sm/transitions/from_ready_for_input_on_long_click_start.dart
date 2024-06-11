part of game_field_sm;

class FromReadyForInputOnLongClickStart {
  late final MoneyUnit _nationMoney;

  late final SimpleStream<GameFieldControlsState> _controlsState;

  FromReadyForInputOnLongClickStart(
    this._nationMoney,
    this._controlsState,
  );

  State process(GameFieldCell cell) {
    _controlsState.update(MainControls(
      money: _nationMoney,
      cellInfo: GameFieldControlsCellInfo(
        income: MoneyCellCalculator.calculateCellIncome(cell),
        terrain: cell.terrain,
        terrainModifier: cell.terrainModifier?.type,
        productionCenter: cell.productionCenter,
      ),
      armyInfo: null,
      carrierInfo: null,
    ));

    return ReadyForInput();
  }
}
