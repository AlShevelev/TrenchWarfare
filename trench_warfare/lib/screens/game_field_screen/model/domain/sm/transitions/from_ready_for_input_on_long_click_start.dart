part of game_field_sm;

class FromReadyForInputOnLongClickStart {
  late final GameFieldStateMachineContext _context;

  FromReadyForInputOnLongClickStart(this._context);

  State process(GameFieldCell cell) {
    _context.controlsState.update(MainControls(
      money: _context.money.actual,
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
