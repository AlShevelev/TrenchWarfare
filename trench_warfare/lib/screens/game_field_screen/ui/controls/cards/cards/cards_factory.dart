part of card_controls;

abstract interface class CardsFactory {
  /// -1 value means no ona card can be selected
  int get startSelectedIndex;

  Iterable<CardBase> getAllCards(OnCardClick onCardClick);
}

class UnitsCardFactory implements CardsFactory {
  late final List<GameFieldControlsUnitCard> _units;

  UnitsCardFactory(List<GameFieldControlsUnitCard> units) {
    _units = units;
  }

  @override
  int get startSelectedIndex =>
      _units.indexWhere((i) => i.canBuildOnGameField && i.canBuildByIndustryPoint && i.canBuildByCurrency);

  @override
  Iterable<CardBase> getAllCards(OnCardClick onCardClick) =>
      _units.asMap().entries.map((u) {
        return CardUnits(
          unit: u.value,
          selected: u.key == startSelectedIndex,
          index: u.key,
          onClick: onCardClick,
        );
      });
}