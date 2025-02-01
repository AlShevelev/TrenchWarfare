part of game_field_sm;

class FromPathIsShownOnClick {
  final GameFieldStateMachineContext _context;

  late final TransitionUtils _transitionUtils = TransitionUtils(_context);

  FromPathIsShownOnClick(this._context);

  State process(Iterable<GameFieldCellRead> path, GameFieldCell cell) {
    final pathToProcess = path.map((i) => i as GameFieldCell).toList(growable: false);

    final firstCell = pathToProcess.first;

    final unit = firstCell.activeUnit!;

    // Click to the unit cell - reset the selection
    if (cell == pathToProcess.first) {
      _hideArmyPanel();
      return _resetPathAndEnableUnit(pathToProcess, unit);
    }

    // Click to the last cell of the path - move the unit
    if (cell == pathToProcess.last) {
      _hideArmyPanel();

      _context.updateGameObjectsEvent.update([_getSoundForUnit(unit)]);

      return MovementFacade(
        nation: _context.nation,
        gameField: _context.gameField,
        updateGameObjectsEvent: _context.updateGameObjectsEvent,
        gameOverConditionsCalculator: _context.gameOverConditionsCalculator,
        animationTime: _context.animationTimeFacade.getAnimationTime(!_context.isAI),
      ).startMovement(pathToProcess);
    }

    // calculate a path
    Iterable<GameFieldCellRead> newPath = _transitionUtils.calculatePath(startCell: firstCell, endCell: cell);

    if (newPath.isEmpty) {
      return _resetPathAndEnableUnit(pathToProcess, unit);
    }

    _resetPath(pathToProcess);

    // show the new path
    final estimatedPath = _transitionUtils.estimatePath(path: newPath);
    if (!_context.isAI) {
      final events = <UpdateGameEvent>[];

      events.add(PlaySound(type: SoundType.buttonClick));
      events.addAll(estimatedPath.map((c) => UpdateCell(c, updateBorderCells: [])));

      _context.updateGameObjectsEvent.update(events);
    }

    return PathIsShown(newPath);
  }

  /// Clear the old path
  void _resetPath(Iterable<GameFieldCell> path) {
    for (var pathCell in path) {
      pathCell.setPathItem(null);
    }
    if (!_context.isAI) {
      _context.updateGameObjectsEvent.update(path.map((c) => UpdateCell(c, updateBorderCells: [])));
    }
  }

  /// Clear the path and make the unit enabled
  State _resetPathAndEnableUnit(Iterable<GameFieldCell> path, Unit unit) {
    unit.setState(UnitState.enabled);
    _resetPath(path);
    return ReadyForInput();
  }

  void _hideArmyPanel() => TransitionUtils(_context).closeUI();

  PlaySound _getSoundForUnit(Unit unit) => PlaySound(type: unit.getProductionSoundType());
}
