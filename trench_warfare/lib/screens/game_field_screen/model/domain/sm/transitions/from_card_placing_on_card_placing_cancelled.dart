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

class FromCardPlacingOnCardPlacingCancelled {
  final GameFieldStateMachineContext _context;

  FromCardPlacingOnCardPlacingCancelled(GameFieldStateMachineContext context): _context = context;

  State process(Map<int, GameFieldCellRead> cellsImpossibleToBuild) {
    TransitionUtils(_context).closeUI();

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
