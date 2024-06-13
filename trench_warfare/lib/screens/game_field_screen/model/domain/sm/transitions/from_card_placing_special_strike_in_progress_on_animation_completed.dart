part of game_field_sm;

class FromCardPlacingSpecialStrikeInProgressOnAnimationCompleted extends GameObjectTransitionBase {
  late final GameFieldControlsCard _card;

  late final Map<int, GameFieldCellRead> _newInactiveCells;

  late final Map<int, GameFieldCellRead> _oldInactiveCells;

  late final MoneyUnit _productionCost;

  late final bool _canPlaceNext;

  FromCardPlacingSpecialStrikeInProgressOnAnimationCompleted(
    super.context, {
    required GameFieldControlsCard card,
    required Map<int, GameFieldCellRead> newInactiveCells,
    required Map<int, GameFieldCellRead> oldInactiveCells,
    required MoneyUnit productionCost,
    required bool canPlaceNext,
  }) {
    _card = card;
    _newInactiveCells = newInactiveCells;
    _oldInactiveCells = oldInactiveCells;
    _productionCost = productionCost;
    _canPlaceNext = canPlaceNext;
  }

  State process() {
    // Update the money
    _context.money.withdraw(_productionCost);

    if (_canPlaceNext) {
      _context.controlsState.update(CardsPlacingControls(
        totalMoney: _context.money.actual,
        card: _card,
      ));

      if (!_context.isAI) {
        _context.updateGameObjectsEvent.update([
          UpdateCellInactivity(
            newInactiveCells: _newInactiveCells,
            oldInactiveCells: _oldInactiveCells,
          )
        ]);
      }

      return CardPlacing(_card, _newInactiveCells);
    } else {
      _context.controlsState.update(MainControls(
        money: _context.money.actual,
        cellInfo: null,
        armyInfo: null,
        carrierInfo: null,
      ));

      if (!_context.isAI) {
        _context.updateGameObjectsEvent.update([
          UpdateCellInactivity(
            newInactiveCells: {},
            oldInactiveCells: _oldInactiveCells,
          )
        ]);
      }

      return ReadyForInput();
    }
  }
}
