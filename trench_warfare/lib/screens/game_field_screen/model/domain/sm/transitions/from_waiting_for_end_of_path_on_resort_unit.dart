part of game_field_sm;

class FromWaitingForEndOfPathOnResortUnit extends GameObjectTransitionBase {
  late final SimpleStream<GameFieldControlsState> _controlsState;

  FromWaitingForEndOfPathOnResortUnit(
    super.updateGameObjectsEvent,
    super.gameField,
    SimpleStream<GameFieldControlsState> controlsState,
  ) {
    _controlsState = controlsState;
  }

  State process(
    GameFieldCell startPathCell,
    int cellId,
    Iterable<String> unitsId, {
    required bool isCarrier,
  }) {
    final cell = _gameField.getCellById(cellId);

    final activeUnit = cell.activeUnit;

    if (isCarrier) {
      (activeUnit! as Carrier).resortUnits(unitsId);

      return WaitingForEndOfPath(startPathCell);
    } else {
      if (activeUnit != null && activeUnit.state == UnitState.active) {
        activeUnit.setState(UnitState.enabled);
      }

      cell.resortUnits(unitsId);

      final newActiveUnit = cell.activeUnit!;

      CarrierPanelCalculator.updateCarrierPanel(
        cellId,
        _controlsState,
        oldActiveUnit: activeUnit!,
        newActiveUnit: newActiveUnit,
      );

      _updateGameObjectsEvent.update([UpdateCell(cell, updateBorderCells: [])]);

      return ReadyForInput();
    }
  }
}
