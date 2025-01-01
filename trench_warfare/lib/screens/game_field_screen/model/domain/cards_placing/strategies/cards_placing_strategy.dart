part of cards_placing;

abstract interface class CardsPlacingStrategy<C extends GameFieldControlsCard<T>, T> {
  @protected
  late final C _card;
  C get card => _card;

  @protected
  T get _type => _card.type;

  @protected
  late final GameFieldCell _cell;
  GameFieldCell get cell => _cell;

  @protected
  late final GameFieldRead _gameField;
  GameFieldRead get gameField => _gameField;

  @protected
  late final Nation _myNation;
  Nation get myNation => _myNation;

  @protected
  late final MoneyStorage _nationMoney;
  MoneyStorage get nationMoney => _nationMoney;

  CardsPlacingStrategy({
    required C card,
    required GameFieldCell cell,
    required MoneyStorage nationMoney,
    required GameFieldRead gameField,
    required Nation myNation,
  }) {
    _card = card;
    _cell = cell;
    _nationMoney = nationMoney;
    _gameField = gameField;
    _myNation = myNation;
  }

  void updateCell();

  MoneyUnit calculateProductionCost();

  List<GameFieldCellRead> getAllCellsImpossibleToBuild();

  PlaySound? getSoundForUnit();
}
