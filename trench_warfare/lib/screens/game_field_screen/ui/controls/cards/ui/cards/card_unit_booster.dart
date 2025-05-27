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

class _CardUnitBooster extends _CardBase<UnitBoost> {
  const _CardUnitBooster({
    super.key,
    required super.card,
    required super.userActions,
  });

  @override
  String _getDescriptionText() => switch (_card.card.type) {
    UnitBoost.attack => tr('attack_card_description'),
    UnitBoost.defence => tr('defence_card_description'),
    UnitBoost.transport => tr('transport_card_description'),
    UnitBoost.commander => tr('commander_card_description'),
  };

  @override
  String _getTitleText() => switch (_card.card.type) {
    UnitBoost.attack => tr('attack_card_name'),
    UnitBoost.defence => tr('defence_card_name'),
    UnitBoost.transport => tr('transport_card_name'),
    UnitBoost.commander => tr('commander_card_name'),
  };

  @override
  CardboardStyle _getCardStyle() => CardboardStyle.green;
}
