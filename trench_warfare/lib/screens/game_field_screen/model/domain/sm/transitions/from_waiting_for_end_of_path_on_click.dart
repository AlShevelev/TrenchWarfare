part of game_field_sm;

class FromWaitingForEndOfPathOnClick extends GameObjectTransitionBase {
  late final NationRecord _nationRecord;

  late final SingleStream<GameFieldControlsState> _controlsState;

  FromWaitingForEndOfPathOnClick(
    super.updateGameObjectsEvent,
    super.gameField,
    NationRecord nationRecord,
    SingleStream<GameFieldControlsState> controlsState
  ) {
    _nationRecord = nationRecord;
    _controlsState = controlsState;
  }

  State process(GameFieldCell startCell, GameFieldCell endCell) {
    final unit = startCell.activeUnit!;

    if (startCell == endCell) {
      // reset the unit active state
      _hideArmyPanel();
      unit.setState(UnitState.enabled);
      _updateGameObjectsEvent.update([UpdateCell(startCell, updateBorderCells: [])]);
      return ReadyForInput();
    }

    // calculate a path
    Iterable<GameFieldCell> path = _calculatePath(startCell: startCell, endCell: endCell, isLandUnit: unit.isLand);

    if (path.isEmpty) {
      // reset the unit active state
      _hideArmyPanel();
      unit.setState(UnitState.enabled);
      _updateGameObjectsEvent.update([UpdateCell(startCell, updateBorderCells: [])]);
      return ReadyForInput();
    }

    final estimatedPath = _estimatePath(path: path, isLandUnit: unit.isLand);
    _updateGameObjectsEvent.update(estimatedPath.map((c) => UpdateCell(c, updateBorderCells: [])));

    return PathIsShown(estimatedPath);
  }

  void _hideArmyPanel() =>
    _controlsState.update(Visible(
      money: _nationRecord.startMoney,
      industryPoints: _nationRecord.startIndustryPoints,
      cellInfo: null,
      armyInfo: null,
    ));
}
