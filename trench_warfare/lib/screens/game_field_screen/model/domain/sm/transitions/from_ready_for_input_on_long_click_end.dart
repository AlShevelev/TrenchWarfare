part of game_field_sm;

class FromReadyForInputOnLongClickEnd {
  late final NationRecord _nationRecord;

  late final SingleStream<GameFieldControlsState> _controlsState;

  FromReadyForInputOnLongClickEnd(
    NationRecord nationRecord,
    SingleStream<GameFieldControlsState> controlsState,
  ) {
    _nationRecord = nationRecord;
    _controlsState = controlsState;
  }

  State process() {
    _controlsState.update(Visible(
      money: _nationRecord.startMoney,
      industryPoints: _nationRecord.startIndustryPoints,
      cellInfo: null,
      armyInfo: null,
    ));

    return ReadyForInput();
  }
}
