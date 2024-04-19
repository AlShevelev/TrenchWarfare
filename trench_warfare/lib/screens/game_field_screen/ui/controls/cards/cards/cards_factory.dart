part of card_controls;

abstract class CardsFactory<T extends BuildPossibility> {
  @protected
  final List<T> items;

  /// -1 value means no ona card can be selected
  int get startSelectedIndex =>
      items.indexWhere((i) => i.canBuildOnGameField && i.canBuildByIndustryPoint && i.canBuildByCurrency);

  CardsFactory(this.items);

  Iterable<CardBase> getAllCards(OnCardClick onCardClick);
}

class UnitsCardFactory extends CardsFactory<GameFieldControlsUnitCard> {
  UnitsCardFactory(super.items);

  @override
  Iterable<CardBase> getAllCards(OnCardClick onCardClick) =>
      items.asMap().entries.map((u) {
        return CardUnit(
          cardInfo: u.value,
          selected: u.key == startSelectedIndex,
          index: u.key,
          onClick: onCardClick,
        );
      });
}

class TerrainModifiersCardFactory extends CardsFactory<GameFieldControlsTerrainModifiersCard> {
  TerrainModifiersCardFactory(super.items);

  @override
  Iterable<CardBase> getAllCards(OnCardClick onCardClick) =>
      items.asMap().entries.map((u) {
        return CardTerrainModifier(
          cardInfo: u.value,
          selected: u.key == startSelectedIndex,
          index: u.key,
          onClick: onCardClick,
        );
      });
}