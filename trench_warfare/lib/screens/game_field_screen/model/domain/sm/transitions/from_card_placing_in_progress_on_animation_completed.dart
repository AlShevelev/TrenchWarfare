part of game_field_sm;

class FromCardPlacingInProgressOnAnimationCompleted extends GameObjectTransitionBase {
  late final GameFieldControlsCard _card;

  late final Map<int, GameFieldCellRead> _newInactiveCells;

  late final Map<int, GameFieldCellRead> _oldInactiveCells;

  late final MoneyUnit _productionCost;

  late final bool _canPlaceNext;

  FromCardPlacingInProgressOnAnimationCompleted(
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
    _context.money.reduceTotalSum(_productionCost);

    if (_canPlaceNext) {
      _context.controlsState.update(CardsPlacingControls(
        totalMoney: _context.money.totalSum,
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
            oldInactiveCells: _oldInactiveCells,
          )
        ]);
      }

      _context.money.recalculateIncomeAndExpenses();
      return ReadyForInput();
    }
  }
}
