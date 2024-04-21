part of card_controls;

class CardTerrainModifier extends CardBase {
  final GameFieldControlsTerrainModifiersCard cardInfo;

  CardTerrainModifier({
    super.key,
    required this.cardInfo,
    required super.selected,
    required super.index,
    required super.onClick,
  });

  @override
  State<StatefulWidget> createState() => _CardTerrainModifierState();
}

class _CardTerrainModifierState extends CardBaseState<CardTerrainModifier> {
  static const _pathToImages = 'assets/images/game_field_overlays/cards/terrain_modifiers/';

  @override
  String _getDescriptionText() => switch (widget.cardInfo.type) {
    TerrainModifierType.seaMine => tr('sea_mine_field_card_description'),
    TerrainModifierType.antiAirGun => tr('anti_air_gun_card_description'),
    TerrainModifierType.landMine => tr('land_mine_field_card_description'),
    TerrainModifierType.landFort => tr('land_fort_card_description'),
    TerrainModifierType.barbedWire => tr('barbed_wire_card_description'),
    TerrainModifierType.trench => tr('trench_card_description'),
  };

  @override
  MoneyUnit _getFooterMoney() => widget.cardInfo.cost;

  @override
  String _getTitleText() => switch (widget.cardInfo.type) {
    TerrainModifierType.seaMine => tr('sea_mine_field_card_name'),
    TerrainModifierType.antiAirGun => tr('anti_air_gun_card_name'),
    TerrainModifierType.landMine => tr('land_mine_field_card_name'),
    TerrainModifierType.landFort => tr('land_fort_card_name'),
    TerrainModifierType.barbedWire => tr('barbed_wire_card_name'),
    TerrainModifierType.trench => tr('trench_card_name'),
  };

  @override
  String getBackgroundImage() => '${_pathToImages}card_background.webp';

  @override
  String _getPhoto() {
    final photo = switch (widget.cardInfo.type) {
      TerrainModifierType.seaMine => 'photo_sea_mine_field.webp',
      TerrainModifierType.antiAirGun => 'photo_anti_air_gun.webp',
      TerrainModifierType.landMine => 'photo_land_mine_field.webp',
      TerrainModifierType.landFort => 'photo_land_fort.webp',
      TerrainModifierType.barbedWire => 'photo_barbed_wire.webp',
      TerrainModifierType.trench => 'photo_trench.webp',
    };

    return '$_pathToImages$photo';
  }

  @override
  BuildRestriction? _getFooterRestriction() => widget.cardInfo.buildDisplayRestriction;

  @override
  BuildPossibility _getBuildPossibility() => widget.cardInfo;
}
