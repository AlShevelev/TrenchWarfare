part of card_controls;

abstract class CardsFactory<T extends GameFieldControlsCard> {
  @protected
  final List<T> items;

  /// -1 value means no ona card can be selected
  int get startSelectedIndex =>
      items.indexWhere((i) => false /*i.buildError == null && i.canBuildByIndustryPoint && i.canBuildByCurrency*/);

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

class UnitBoosterCardFactory extends CardsFactory<GameFieldControlsUnitBoostersCard> {
  UnitBoosterCardFactory(super.items);

  @override
  Iterable<CardBase> getAllCards(OnCardClick onCardClick) =>
      items.asMap().entries.map((u) {
        return CardUnitBooster(
          cardInfo: u.value,
          selected: u.key == startSelectedIndex,
          index: u.key,
          onClick: onCardClick,
        );
      });
}

class SpecialStrikesCardFactory extends CardsFactory<GameFieldControlsSpecialStrikesCard> {
  SpecialStrikesCardFactory(super.items);

  @override
  Iterable<CardBase> getAllCards(OnCardClick onCardClick) =>
      items.asMap().entries.map((u) {
        return CardSpecialStrike(
          cardInfo: u.value,
          selected: u.key == startSelectedIndex,
          index: u.key,
          onClick: onCardClick,
        );
      });
}

class ProductionCentersCardFactory extends CardsFactory<GameFieldControlsProductionCentersCard> {
  ProductionCentersCardFactory(super.items);

  @override
  Iterable<CardBase> getAllCards(OnCardClick onCardClick) =>
      items.asMap().entries.map((u) {
        return CardProductionCenter(
          cardInfo: u.value,
          selected: u.key == startSelectedIndex,
          index: u.key,
          onClick: onCardClick,
        );
      });
}