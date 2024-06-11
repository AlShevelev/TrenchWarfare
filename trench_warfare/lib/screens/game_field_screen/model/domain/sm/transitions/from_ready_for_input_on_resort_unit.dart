part of game_field_sm;

class FromReadyForInputOnResortUnit extends GameObjectTransitionBase {
  late final SimpleStream<GameFieldControlsState> _controlsState;

  FromReadyForInputOnResortUnit(
    super.updateGameObjectsEvent,
    super.gameField,
    SimpleStream<GameFieldControlsState> controlsState,
  ) {
    _controlsState = controlsState;
  }

  State process(int cellId, Iterable<String> unitsId, {required bool isCarrier}) {
    final cell = _gameField.getCellById(cellId);

    final activeUnit = cell.activeUnit!;

    if (isCarrier) {
      (activeUnit as Carrier).resortUnits(unitsId);
    } else {
      cell.resortUnits(unitsId);

      final newActiveUnit = cell.activeUnit!;

      CarrierPanelCalculator.updateCarrierPanel(
        cellId,
        _controlsState,
        oldActiveUnit: activeUnit,
        newActiveUnit: newActiveUnit,
      );

      _updateGameObjectsEvent.update([UpdateCell(cell, updateBorderCells: [])]);
    }

    return ReadyForInput();
  }
}
