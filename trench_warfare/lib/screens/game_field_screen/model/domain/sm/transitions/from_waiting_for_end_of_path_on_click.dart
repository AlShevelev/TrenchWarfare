part of game_field_sm;

class FromWaitingForEndOfPathOnClick {
  final GameFieldStateMachineContext _context;

  late final TransitionUtils _transitionUtils = TransitionUtils(_context);

  FromWaitingForEndOfPathOnClick(this._context);

  State process(GameFieldCell startCell, GameFieldCell endCell) {
    final unit = startCell.activeUnit!;

    if (startCell == endCell) {
      // reset the unit active state
      _hideArmyPanel();
      unit.setState(UnitState.enabled);
      _context.updateGameObjectsEvent.update([UpdateCell(startCell)]);
      return ReadyForInput();
    }

    // calculate a path
    Iterable<GameFieldCellRead> path = _transitionUtils.calculatePath(startCell: startCell, endCell: endCell);

    if (path.isEmpty) {
      // reset the unit active state
      _hideArmyPanel();
      unit.setState(UnitState.enabled);

      if (!_context.isAI) {
        _context.updateGameObjectsEvent.update([UpdateCell(startCell)]);
      }
      return ReadyForInput();
    }

    final estimatedPath = _transitionUtils.estimatePath(path: path);
    if (!_context.isAI) {
      _context.updateGameObjectsEvent.update(estimatedPath.map((c) => UpdateCell(c)));
    }

    return PathIsShown(estimatedPath);
  }

  void _hideArmyPanel() => TransitionUtils(_context).closeUI();
}
