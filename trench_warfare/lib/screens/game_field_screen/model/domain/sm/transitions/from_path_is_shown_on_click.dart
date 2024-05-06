part of game_field_sm;

class FromPathIsShownOnClick extends GameObjectTransitionBase {
  late final Nation _nation;

  late final MoneyUnit _nationMoney;

  late final SingleStream<GameFieldControlsState> _controlsState;

  FromPathIsShownOnClick(
    super.updateGameObjectsEvent,
    super.gameField,
    this._nation,
    this._nationMoney,
    this._controlsState,
  );

  State process(Iterable<GameFieldCell> path, GameFieldCell cell) {
    final firstCell = path.first;

    final unit = firstCell.activeUnit!;

    if (cell == path.first) {
      _hideArmyPanel();
      return _resetPathAndEnableUnit(path, unit);
    }

    if (cell == path.last) {
      _controlsState.update(MainControls(
        money: _nationMoney,
        cellInfo: null,
        armyInfo: null,
      ));

      return MovementFacade(
        nation: _nation,
        gameField: _gameField,
        updateGameObjectsEvent: _updateGameObjectsEvent,
      ).startMovement(path);
    }

    // calculate a path
    Iterable<GameFieldCell> newPath = _calculatePath(startCell: firstCell, endCell: cell, isLandUnit: unit.isLand);

    if (newPath.isEmpty) {
      return _resetPathAndEnableUnit(path, unit);
    }

    _resetPath(path);

    // show the new path
    final estimatedPath = _estimatePath(path: newPath, isLandUnit: unit.isLand);
    _updateGameObjectsEvent.update(estimatedPath.map((c) => UpdateCell(c, updateBorderCells: [])));

    return PathIsShown(newPath);
  }

  /// Clear the old path
  void _resetPath(Iterable<GameFieldCell> path) {
    for (var pathCell in path) {
      pathCell.setPathItem(null);
    }
    _updateGameObjectsEvent.update(path.map((c) => UpdateCell(c, updateBorderCells: [])));
  }

  /// Clear the path and make the unit enabled
  State _resetPathAndEnableUnit(Iterable<GameFieldCell> path, Unit unit) {
    unit.setState(UnitState.enabled);
    _resetPath(path);
    return ReadyForInput();
  }

  void _hideArmyPanel() =>
      _controlsState.update(MainControls(
        money: _nationMoney,
        cellInfo: null,
        armyInfo: null,
      ));
}
