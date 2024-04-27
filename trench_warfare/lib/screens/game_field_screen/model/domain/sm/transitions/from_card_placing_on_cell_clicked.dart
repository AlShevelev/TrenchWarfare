part of game_field_sm;

class FromCardPlacingOnCellClicked extends GameObjectTransitionBase {
  late final MoneyStorage _nationMoney;

  late final SingleStream<GameFieldControlsState> _controlsState;

  late final Nation _myNation;

  FromCardPlacingOnCellClicked(
    super.updateGameObjectsEvent,
    super.gameField, {
    required MoneyStorage nationMoney,
    required SingleStream<GameFieldControlsState> controlsState,
    required Nation myNation,
  }) {
    _nationMoney = nationMoney;
    _controlsState = controlsState;
    _myNation = myNation;
  }

  State process(Map<int, GameFieldCellRead> cellsImpossibleToBuild, GameFieldCell cell, GameFieldControlsCard card) {
    // do noting if a user clicked an invalid cell
    if (cellsImpossibleToBuild.containsKey(cell.id)) {
      return CardPlacing(card, cellsImpossibleToBuild);
    }

    final PlacingCalculator calculator = switch(card) {
      GameFieldControlsUnitCard() => UnitCardPlacingCalculator(
        card: card,
        cell: cell,
        nationMoney: _nationMoney,
        updateGameObjectsEvent: _updateGameObjectsEvent,
        gameField: _gameField,
        myNation: _myNation,
        controlsState: _controlsState,
        oldInactiveCells: cellsImpossibleToBuild,
      ),
      GameFieldControlsUnitBoostersCard() => UnitBoostCardPlacingCalculator(
        card: card,
        cell: cell,
        nationMoney: _nationMoney,
        updateGameObjectsEvent: _updateGameObjectsEvent,
        gameField: _gameField,
        myNation: _myNation,
        controlsState: _controlsState,
        oldInactiveCells: cellsImpossibleToBuild,
      ),
      _ => throw UnsupportedError(''),
    };

    return calculator.place();
  }
}
