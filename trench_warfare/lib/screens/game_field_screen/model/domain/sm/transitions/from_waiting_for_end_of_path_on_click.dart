part of game_field_sm;

class FromWaitingForEndOfPathOnClick extends GameObjectTransitionBase {
  late final MoneyUnit _nationMoney;

  late final SingleStream<GameFieldControlsState> _controlsState;

  FromWaitingForEndOfPathOnClick(
    super.updateGameObjectsEvent,
    super.gameField,
    this._nationMoney,
    this._controlsState,
  );

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
    Iterable<GameFieldCell> path = _calculatePath(startCell: startCell, endCell: endCell);

    if (path.isEmpty) {
      // reset the unit active state
      _hideArmyPanel();
      unit.setState(UnitState.enabled);
      _updateGameObjectsEvent.update([UpdateCell(startCell, updateBorderCells: [])]);
      return ReadyForInput();
    }

    final estimatedPath = _estimatePath(path: path);
    _updateGameObjectsEvent.update(estimatedPath.map((c) => UpdateCell(c, updateBorderCells: [])));

    return PathIsShown(estimatedPath);
  }

  void _hideArmyPanel() =>
    _controlsState.update(MainControls(
      money: _nationMoney,
      cellInfo: null,
      armyInfo: null,
      carrierInfo: null,
    ));
}
