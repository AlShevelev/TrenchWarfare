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