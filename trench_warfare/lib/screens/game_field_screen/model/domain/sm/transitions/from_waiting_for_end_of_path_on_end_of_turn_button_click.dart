part of game_field_sm;

class FromWaitingForEndOfPathOnEndOfTurnButtonClick extends GameObjectTransitionBase {
  FromWaitingForEndOfPathOnEndOfTurnButtonClick(super.context);

  State process(GameFieldCell startCell) {
    final unit = startCell.activeUnit!;

    _hideArmyPanel();
    unit.setState(UnitState.enabled);
    _context.updateGameObjectsEvent.update([UpdateCell(startCell, updateBorderCells: [])]);

    // todo there will be a model switch here
    return TurnIsEnded();
  }

  void _hideArmyPanel() => _context.controlsState.update(
        MainControls(
          totalSum: _context.money.totalSum,
          cellInfo: null,
          armyInfo: null,
          carrierInfo: null,
        ),
      );
}
