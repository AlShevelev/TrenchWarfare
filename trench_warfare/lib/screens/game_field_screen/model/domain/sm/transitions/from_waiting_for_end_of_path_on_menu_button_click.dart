part of game_field_sm;

class FromWaitingForEndOfPathOnMenuButtonClick extends FromReadyForInputOnMenuButtonClick {
  final GameFieldCellRead _startPathCell;

  FromWaitingForEndOfPathOnMenuButtonClick(super.context, GameFieldCellRead startPathCell)
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
