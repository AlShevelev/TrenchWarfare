part of game_field_sm;

class FromCardPlacingOnCardPlacingCancelled extends GameObjectTransitionBase {
  FromCardPlacingOnCardPlacingCancelled(super.context);

  State process(Map<int, GameFieldCellRead> cellsImpossibleToBuild) {
    _context.controlsState.update(MainControls(
      money: _context.money.actual,
      cellInfo: null,
      armyInfo: null,
      carrierInfo: null,
    ));

    _context.updateGameObjectsEvent.update([
      UpdateCellInactivity(
        newInactiveCells: {},
        oldInactiveCells: cellsImpossibleToBuild,
      )
    ]);

    return ReadyForInput();
  }
}
