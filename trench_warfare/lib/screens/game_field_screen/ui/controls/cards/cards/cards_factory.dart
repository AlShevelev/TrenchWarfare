part of card_controls;

abstract interface class CardsFactory {
  int get selectedIndex;

  Iterable<CardBase> getAllCards(OnCardClick onCardClick);
}

class UnitsCardFactory implements CardsFactory {
  late final List<GameFieldControlsUnitCard> _units;

  UnitsCardFactory(List<GameFieldControlsUnitCard> units) {
    _units = units;
  }

  @override
  int get selectedIndex => 0;

  @override
  Iterable<CardBase> getAllCards(OnCardClick onCardClick) =>
      _units.asMap().entries.map((u) {
        return CardUnits(
          unit: u.value,
          selected: u.key == selectedIndex,
          index: u.key,
          onClick: onCardClick,
        );
      });
}