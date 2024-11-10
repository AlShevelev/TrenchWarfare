part of card_controls;

abstract class _CardsFactory<T> {
  @protected
  final List<_CardDto<T>> cards;

  @protected
  final _CardsSelectionUserActions userActions;

  _CardsFactory(this.cards, this.userActions);

  Iterable<_CardBase> getAllCards();
}

class _UnitsCardFactory extends _CardsFactory<UnitType> {
  _UnitsCardFactory(super.cards, super.userActions);

  @override
  Iterable<_CardBase> getAllCards() => cards.map((c) => _CardUnit(card: c, userActions: userActions));
}

class _TerrainModifiersCardFactory extends _CardsFactory<TerrainModifierType> {
  _TerrainModifiersCardFactory(super.cards, super.userActions);

  @override
  Iterable<_CardBase> getAllCards() => cards.map(
        (c) => _CardTerrainModifier(
          card: c,
          userActions: userActions,
        ),
      );
}

class _UnitBoosterCardFactory extends _CardsFactory<UnitBoost> {
  _UnitBoosterCardFactory(super.cards, super.userActions);

  @override
  Iterable<_CardBase> getAllCards() => cards.map((c) => _CardUnitBooster(card: c, userActions: userActions));
}

class _SpecialStrikesCardFactory extends _CardsFactory<SpecialStrikeType> {
  _SpecialStrikesCardFactory(super.cards, super.userActions);

  @override
  Iterable<_CardBase> getAllCards() => cards.map(
        (c) => _CardSpecialStrike(
          card: c,
          userActions: userActions,
        ),
      );
}

class _ProductionCentersCardFactory extends _CardsFactory<ProductionCenterType> {
  _ProductionCentersCardFactory(super.cards, super.userActions);

  @override
  Iterable<_CardBase> getAllCards() => cards.map(
        (c) => _CardProductionCenter(
          card: c,
          userActions: userActions,
        ),
      );
}
