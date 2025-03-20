part of game_field_sm;

class FromCardPlacingInProgressOnAnimationCompleted {
  final GameFieldStateMachineContext _context;

  final GameFieldControlsCard _card;

  final Map<int, GameFieldCellRead> _newInactiveCells;

  final Map<int, GameFieldCellRead> _oldInactiveCells;

  final MoneyUnit _productionCost;

  final bool _canPlaceNext;

  FromCardPlacingInProgressOnAnimationCompleted({
    required GameFieldStateMachineContext context,
    required GameFieldControlsCard card,
    required Map<int, GameFieldCellRead> newInactiveCells,
    required Map<int, GameFieldCellRead> oldInactiveCells,
    required MoneyUnit productionCost,
    required bool canPlaceNext,
  })  : _context = context,
        _card = card,
        _newInactiveCells = newInactiveCells,
        _oldInactiveCells = oldInactiveCells,
        _productionCost = productionCost,
        _canPlaceNext = canPlaceNext;

  State process() {
    // Update the money
    _context.money.reduceTotalSum(_productionCost);

    if (_canPlaceNext) {
      _context.controlsState.update(CardsPlacingControls(
        totalMoney: _context.money.totalSum,
        card: _card,
        nation: _context.myNation,
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
      TransitionUtils(_context).closeUI();

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
