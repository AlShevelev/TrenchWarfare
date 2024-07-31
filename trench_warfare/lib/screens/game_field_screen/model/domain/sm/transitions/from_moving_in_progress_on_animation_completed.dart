part of game_field_sm;

class FromMovingInProgressOnAnimationCompleted extends GameObjectTransitionBase {
  FromMovingInProgressOnAnimationCompleted(super.context);

  State process(bool isVictory, Nation? defeated) {
    if (isVictory) {
      if (_context.isAI) {
        _context.controlsState.update(DefeatControls(
          nation: _context.nation,
          isGlobal: true,
        ));
      } else {
        _context.controlsState.update(WinControls(
          nation: _context.nation,
        ));
      }

      return VictoryDefeatConfirmation(isVictory: isVictory);
    }

    if (defeated != null) {
      _context.controlsState.update(DefeatControls(
        nation: defeated,
        isGlobal: false,
      ));

      return VictoryDefeatConfirmation(isVictory: isVictory);
    }

    return ReadyForInput();
  }
}
