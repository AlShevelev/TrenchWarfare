part of game_field_sm;

class FromReadyForInputOnLongClickStart {
  late final GameFieldStateMachineContext _context;

  FromReadyForInputOnLongClickStart(this._context);

  State process(GameFieldCell cell) {
    _context.controlsState.update(
      MainControls(
        totalSum: _context.money.totalSum,
        cellInfo: GameFieldControlsCellInfo(
          income: MoneyCellCalculator.calculateCellIncome(cell),
          terrain: cell.terrain,
          terrainModifier: cell.terrainModifier?.type,
          productionCenter: cell.productionCenter,
        ),
        armyInfo: null,
        carrierInfo: null,
        nation: _context.nation,
      ),
    );

    return ReadyForInput();
  }
}
