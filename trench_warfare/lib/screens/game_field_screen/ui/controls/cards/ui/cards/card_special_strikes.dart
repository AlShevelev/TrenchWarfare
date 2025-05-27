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

class _CardSpecialStrike extends _CardBase<SpecialStrikeType> {
  const _CardSpecialStrike({
    super.key,
    required super.card,
    required super.userActions,
  });

  @override
  String _getDescriptionText() => switch (_card.card.type) {
    SpecialStrikeType.gasAttack => tr('gas_attack_card_description'),
    SpecialStrikeType.flechettes => tr('flechettes_card_description'),
    SpecialStrikeType.airBombardment => tr('air_bombing_card_description'),
    SpecialStrikeType.flameTroopers => tr('flametroopers_card_description'),
    SpecialStrikeType.propaganda => tr('propaganda_card_description'),
  };

  @override
  String _getTitleText() => switch (_card.card.type) {
    SpecialStrikeType.gasAttack => tr('gas_attack_card_name'),
    SpecialStrikeType.flechettes => tr('flechettes_card_name'),
    SpecialStrikeType.airBombardment => tr('air_bombing_card_name'),
    SpecialStrikeType.flameTroopers => tr('flametroopers_card_name'),
    SpecialStrikeType.propaganda => tr('propaganda_card_name'),
  };

  @override
  CardboardStyle _getCardStyle() => CardboardStyle.brown;
}
