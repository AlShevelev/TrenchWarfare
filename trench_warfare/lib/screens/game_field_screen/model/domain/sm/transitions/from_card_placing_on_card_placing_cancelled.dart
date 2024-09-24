part of game_field_sm;

class FromCardPlacingOnCardPlacingCancelled extends GameObjectTransitionBase {
  FromCardPlacingOnCardPlacingCancelled(super.context);

  State process(Map<int, GameFieldCellRead> cellsImpossibleToBuild) {
    _context.controlsState.update(
      MainControls(
        totalSum: _context.money.totalSum,
        cellInfo: null,
        armyInfo: null,
        carrierInfo: null,
      ),
    );

    if (!_context.isAI) {
      _context.updateGameObjectsEvent.update([
        UpdateCellInactivity(
          newInactiveCells: {},
          oldInactiveCells: cellsImpossibleToBuild,
        )
      ]);
    }

    return ReadyForInput();
  }
}
