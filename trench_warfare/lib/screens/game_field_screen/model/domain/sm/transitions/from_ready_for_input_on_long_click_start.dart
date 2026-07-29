/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

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
          nation: cell.nation,
          units: cell.units.toList(growable: false),
        ),
        armyInfo: null,
        carrierInfo: null,
        nation: _context.myNation,
        showDismissButton: false,
        showNextActiveUnitButton: false,
      ),
    );

    return ReadyForInput();
  }
}
