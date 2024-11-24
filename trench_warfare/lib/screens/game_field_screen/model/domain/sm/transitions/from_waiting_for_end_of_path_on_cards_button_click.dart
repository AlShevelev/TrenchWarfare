part of game_field_sm;

class FromWaitingForEndOfPathOnCardsButtonClick extends FromReadyForInputOnCardsButtonClick {
  final GameFieldCellRead _startPathCell;

  FromWaitingForEndOfPathOnCardsButtonClick(super.context, GameFieldCellRead startPathCell)
      : _startPathCell = startPathCell;

  @override
  State process() {
    // The unit's deactivation
    _startPathCell.activeUnit?.setState(UnitState.enabled);

    _context.updateGameObjectsEvent.update([
      UpdateCell(_startPathCell as GameFieldCell)
    ]);

    return super.process();
  }
}
