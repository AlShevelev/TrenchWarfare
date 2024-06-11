part of game_field_sm;

class FromWaitingForEndOfPathOnEndOfTurnButtonClick extends GameObjectTransitionBase {
  late final MoneyUnit _nationMoney;

  late final SimpleStream<GameFieldControlsState> _controlsState;

  FromWaitingForEndOfPathOnEndOfTurnButtonClick(
      super.updateGameObjectsEvent,
      super.gameField,
      this._nationMoney,
      this._controlsState,
      );

  State process(GameFieldCell startCell) {
    final unit = startCell.activeUnit!;

    _hideArmyPanel();
    unit.setState(UnitState.enabled);
    _updateGameObjectsEvent.update([UpdateCell(startCell, updateBorderCells: [])]);

    // todo there will be a model switch here
    return TurnIsEnded();
  }

  void _hideArmyPanel() =>
      _controlsState.update(MainControls(
        money: _nationMoney,
        cellInfo: null,
        armyInfo: null,
        carrierInfo: null,
      ));
}
