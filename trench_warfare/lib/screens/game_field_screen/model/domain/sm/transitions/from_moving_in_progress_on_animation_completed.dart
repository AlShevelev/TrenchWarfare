/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of game_field_sm;

class FromMovingInProgressOnAnimationCompleted {
  final GameFieldStateMachineContext _context;

  FromMovingInProgressOnAnimationCompleted(this._context);

  State process(bool isVictory, Nation? defeated, Iterable<GameFieldCellRead> cellsToUpdate) {
    if (isVictory) {
      // Enemy nation is win
      if (_context.isAI && _context.mapMetadata.isInWar(_context.humanNation, _context.myNation)) {
        _context.updateGameObjectsEvent.update([
          PlaySound(type: SoundType.battleResultDefeat),
        ]);

        _context.controlsState.update(DefeatControls(
          nation: _context.myNation,
          isGlobal: true,
        ));
      } else {    // Numan nation or one of its ally is win
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
