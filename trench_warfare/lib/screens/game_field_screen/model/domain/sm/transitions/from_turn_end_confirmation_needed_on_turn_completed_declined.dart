part of game_field_sm;

class FromTurnEndConfirmationNeededOnTurnCompletedDeclined {
  final GameFieldStateMachineContext _context;

  FromTurnEndConfirmationNeededOnTurnCompletedDeclined(this._context);

  State process(GameFieldCellRead cellToMoveCamera) {
    TransitionUtils(_context).closeUI();

    _context.updateGameObjectsEvent.update([MoveCameraToCell(cellToMoveCamera)]);

    return ReadyForInput();
  }
}