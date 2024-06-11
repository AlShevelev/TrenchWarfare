part of game_field_sm;

class FromPathIsShownOnResortUnit extends GameObjectTransitionBase {
  late final SimpleStream<GameFieldControlsState> _controlsState;

  FromPathIsShownOnResortUnit(
    super.updateGameObjectsEvent,
    super.gameField,
    SimpleStream<GameFieldControlsState> controlsState,
  ) {
    _controlsState = controlsState;
  }

  State process(Iterable<GameFieldCell> path, int cellId, Iterable<String> unitsId, {required bool isCarrier}) {
    final cell = _gameField.getCellById(cellId);

    final activeUnit = cell.activeUnit!;

    if (activeUnit.state == UnitState.active) {
      activeUnit.setState(UnitState.enabled);
    }

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
    }

    for (var pathCell in path) {
      pathCell.setPathItem(null);
    }

    _updateGameObjectsEvent.update(path.map((c) => UpdateCell(c, updateBorderCells: [])));

    return ReadyForInput();
  }
}
