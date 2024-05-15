part of game_field_sm;

class FromReadyForInputOnEndOfTurnButtonClick {
  State process() {
    // todo there will be a model switch here
    return TurnIsEnded();
  }
}
