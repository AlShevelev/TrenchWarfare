part of game_field_sm;

class FromCardPlacingOnCellClicked extends GameObjectTransitionBase {
  late final MoneyUnit _nationMoney;

  late final SingleStream<GameFieldControlsState> _controlsState;

  FromCardPlacingOnCellClicked(
    super.updateGameObjectsEvent,
    super.gameField, {
    required MoneyUnit nationMoney,
    required SingleStream<GameFieldControlsState> controlsState,
  }) {
    _nationMoney = nationMoney;
    _controlsState = controlsState;
  }

  State process(Map<int, GameFieldCellRead> cellsImpossibleToBuild, GameFieldCell cell, GameFieldControlsCard card) {
    // do noting if a user clicked an invalid cell
    if (cellsImpossibleToBuild.containsKey(cell.id)) {
      return CardPlacing(card, cellsImpossibleToBuild);
    }

    throw UnsupportedError('');
  }
}
