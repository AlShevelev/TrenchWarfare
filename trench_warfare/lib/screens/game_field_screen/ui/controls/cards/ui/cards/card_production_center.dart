/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of card_controls;

class _CardProductionCenter extends _CardBase<ProductionCenterType> {
  const _CardProductionCenter({
    super.key,
    required super.card,
    required super.userActions,
  });

  @override
  String _getDescriptionText() => switch (_card.card.type) {
    ProductionCenterType.city => tr('city_card_description'),
    ProductionCenterType.factory => tr('factory_card_description'),
    ProductionCenterType.airField => tr('air_field_card_description'),
    ProductionCenterType.navalBase => tr('naval_base_card_description'),
  };

  @override
  String _getTitleText() => switch (_card.card.type) {
    ProductionCenterType.city => tr('city_card_name'),
    ProductionCenterType.factory => tr('factory_card_name'),
    ProductionCenterType.airField => tr('air_field_card_name'),
    ProductionCenterType.navalBase => tr('naval_base_card_name'),
  };

  @override
  CardboardStyle _getCardStyle() => CardboardStyle.blue;
}
