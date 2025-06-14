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

class FromReadyForInputOnResortUnit {
  final GameFieldStateMachineContext _context;

  FromReadyForInputOnResortUnit(this._context);

  State process(int cellId, Iterable<String> unitsId, {required bool isCarrier}) {
    final cell = _context.gameField.getCellById(cellId);

    final activeUnit = cell.activeUnit!;

    if (isCarrier) {
      (activeUnit as Carrier).resortUnits(unitsId);
    } else {
      cell.resortUnits(unitsId);

      final newActiveUnit = cell.activeUnit!;

      CarrierPanelCalculator.updateCarrierPanel(
        cellId,
        cell.nation!,
        _context.controlsState,
        oldActiveUnit: activeUnit,
        newActiveUnit: newActiveUnit,
      );

      _context.updateGameObjectsEvent.update([UpdateCell(cell, updateBorderCells: [])]);
    }

    return ReadyForInput();
  }
}
