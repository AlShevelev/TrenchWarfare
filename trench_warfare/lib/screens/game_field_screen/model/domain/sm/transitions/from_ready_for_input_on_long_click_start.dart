part of game_field_sm;

class FromReadyForInputOnLongClickStart {
  late final NationRecord _nationRecord;

  late final SingleStream<GameFieldControlsState> _controlsState;

  FromReadyForInputOnLongClickStart(
    NationRecord nationRecord,
    SingleStream<GameFieldControlsState> controlsState,
  ) {
    _nationRecord = nationRecord;
    _controlsState = controlsState;
  }

  State process(GameFieldCell cell) {
    _controlsState.update(Visible(
      money: _nationRecord.startMoney,
      industryPoints: _nationRecord.startIndustryPoints,
      cellInfo: GameFieldControlsCellInfo(
        money: 0,
        industryPoints: 0,
        terrain: cell.terrain,
        terrainModifier: cell.terrainModifier?.type,
        productionCenter: cell.productionCenter,
      ),
      armyInfo: null,
    ));

    return ReadyForInput();
  }
}
