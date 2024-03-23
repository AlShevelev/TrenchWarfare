part of game_field_sm;

class FromReadyForInputOnLongClickStart {
  late final MoneyUnit _nationMoney;

  late final SingleStream<GameFieldControlsState> _controlsState;

  FromReadyForInputOnLongClickStart(
    this._nationMoney,
    this._controlsState,
  );

  State process(GameFieldCell cell) {
    _controlsState.update(Visible(
      money: _nationMoney,
      cellInfo: GameFieldControlsCellInfo(
        income: MoneyCellCalculator.getCellIncome(cell),
        terrain: cell.terrain,
        terrainModifier: cell.terrainModifier?.type,
        productionCenter: cell.productionCenter,
      ),
      armyInfo: null,
    ));

    return ReadyForInput();
  }
}
