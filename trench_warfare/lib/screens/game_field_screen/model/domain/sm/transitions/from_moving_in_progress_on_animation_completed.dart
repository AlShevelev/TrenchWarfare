part of game_field_sm;

class FromMovingInProgressOnAnimationCompleted {
  final GameFieldStateMachineContext _context;

  FromMovingInProgressOnAnimationCompleted(this._context);

  State process(bool isVictory, Nation? defeated, Iterable<GameFieldCellRead> cellsToUpdate) {
    if (isVictory) {
      if (_context.isAI) {
        _context.updateGameObjectsEvent.update([
          PlaySound(type: SoundType.battleResultDefeat),
        ]);

        _context.controlsState.update(DefeatControls(
          nation: _context.myNation,
          isGlobal: true,
        ));
      } else {
        _context.updateGameObjectsEvent.update([
          PlaySound(type: SoundType.battleResultVictory),
        ]);

        _context.controlsState.update(WinControls(
          nation: _context.myNation,
        ));
      }

      return VictoryDefeatConfirmation(isVictory: isVictory, cellsToUpdate: cellsToUpdate);
    }

    if (defeated != null) {
      _context.controlsState.update(DefeatControls(
        nation: defeated,
        isGlobal: false,
      ));

      return VictoryDefeatConfirmation(isVictory: isVictory, cellsToUpdate: cellsToUpdate);
    }

    _context.money.recalculateIncomeAndExpenses();
    return ReadyForInput();
  }
}
