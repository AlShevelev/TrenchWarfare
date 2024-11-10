part of card_controls;

class _CardTerrainModifier extends _CardBase<TerrainModifierType> {
  const _CardTerrainModifier({
    super.key,
    required super.card,
    required super.userActions,
  });

  @override
  String _getDescriptionText() => switch (_card.card.type) {
    TerrainModifierType.seaMine => tr('sea_mine_field_card_description'),
    TerrainModifierType.antiAirGun => tr('anti_air_gun_card_description'),
    TerrainModifierType.landMine => tr('land_mine_field_card_description'),
    TerrainModifierType.landFort => tr('land_fort_card_description'),
    TerrainModifierType.barbedWire => tr('barbed_wire_card_description'),
    TerrainModifierType.trench => tr('trench_card_description'),
  };

  @override
  MoneyUnit _getFooterMoney() => _card.card.cost;

  @override
  String _getTitleText() => switch (_card.card.type) {
    TerrainModifierType.seaMine => tr('sea_mine_field_card_name'),
    TerrainModifierType.antiAirGun => tr('anti_air_gun_card_name'),
    TerrainModifierType.landMine => tr('land_mine_field_card_name'),
    TerrainModifierType.landFort => tr('land_fort_card_name'),
    TerrainModifierType.barbedWire => tr('barbed_wire_card_name'),
    TerrainModifierType.trench => tr('trench_card_name'),
  };

  @override
  String getBackgroundImage() => 'assets/images/screens/shared/card_yellow_background.webp';
}
