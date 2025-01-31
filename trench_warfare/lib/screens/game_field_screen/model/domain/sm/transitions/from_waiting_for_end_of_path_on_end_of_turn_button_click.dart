part of game_field_sm;

class FromWaitingForEndOfPathOnEndOfTurnButtonClick {
  final GameFieldStateMachineContext _context;

  FromWaitingForEndOfPathOnEndOfTurnButtonClick(this._context);

  State process(GameFieldCell startCell) {
    final unit = startCell.activeUnit!;

    _hideArmyPanel();
    unit.setState(UnitState.enabled);
    _context.updateGameObjectsEvent.update([UpdateCell(startCell, updateBorderCells: [])]);

    return TransitionUtils(_context).processEndOfTurn();
  }

  void _hideArmyPanel() => TransitionUtils(_context).closeUI();
}
