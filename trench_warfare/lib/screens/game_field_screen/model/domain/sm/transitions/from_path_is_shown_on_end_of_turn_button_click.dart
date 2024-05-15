part of game_field_sm;

class FromPathIsShownOnEndOfTurnButtonClick extends GameObjectTransitionBase {
  late final MoneyUnit _nationMoney;

  late final SingleStream<GameFieldControlsState> _controlsState;

  FromPathIsShownOnEndOfTurnButtonClick(
      super.updateGameObjectsEvent,
      super.gameField,
      this._nationMoney,
      this._controlsState,
      );

  State process(Iterable<GameFieldCell> path) {
    final unit = path.first.activeUnit!;

    // Click to the unit cell - reset the selection
    _hideArmyPanel();

    unit.setState(UnitState.enabled);

    _resetPath(path);

    return TurnIsEnded();
  }

  /// Clear the old path
  void _resetPath(Iterable<GameFieldCell> path) {
    for (var pathCell in path) {
      pathCell.setPathItem(null);
    }
    _updateGameObjectsEvent.update(path.map((c) => UpdateCell(c, updateBorderCells: [])));
  }

  void _hideArmyPanel() =>
      _controlsState.update(MainControls(
        money: _nationMoney,
        cellInfo: null,
        armyInfo: null,
        carrierInfo: null,
      ));
}
