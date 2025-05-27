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

class FromTurnEndConfirmationNeededOnUserDeclined {
  final GameFieldStateMachineContext _context;

  FromTurnEndConfirmationNeededOnUserDeclined(this._context);

  State process(GameFieldCellRead cellToMoveCamera) {
    TransitionUtils(_context).closeUI();

    //_context.updateGameObjectsEvent.update([MoveCameraToCell(cellToMoveCamera)]);

    return ReadyForInput();
  }
}