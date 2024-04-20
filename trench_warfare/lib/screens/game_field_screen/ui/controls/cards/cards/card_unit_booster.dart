part of card_controls;

class CardUnitBooster extends CardBase {
  final GameFieldControlsUnitBoostersCard cardInfo;

  CardUnitBooster({
    super.key,
    required this.cardInfo,
    required super.selected,
    required super.index,
    required super.onClick,
  });

  @override
  State<StatefulWidget> createState() => _CardUnitBoosterState();
}

class _CardUnitBoosterState extends CardBaseState<CardUnitBooster> {
  static const _pathToImages = 'assets/images/game_field_overlays/cards/troop_boosters/';

  @override
  String _getDescriptionText() => switch (widget.cardInfo.type) {
    UnitBoost.attack => tr('attack_card_description'),
    UnitBoost.defence => tr('defence_card_description'),
    UnitBoost.transport => tr('transport_card_description'),
    UnitBoost.commander => tr('commander_card_description'),
  };

  @override
  MoneyUnit _getFooterMoney() => widget.cardInfo.cost;

  @override
  String _getTitleText() => switch (widget.cardInfo.type) {
    UnitBoost.attack => tr('attack_card_name'),
    UnitBoost.defence => tr('defence_card_name'),
    UnitBoost.transport => tr('transport_card_name'),
    UnitBoost.commander => tr('commander_card_name'),
  };

  @override
  String getBackgroundImage() => '${_pathToImages}card_background.webp';

  @override
  String _getPhoto() {
    final photo = switch (widget.cardInfo.type) {
      UnitBoost.attack => 'photo_attack.webp',
      UnitBoost.defence => 'photo_defence.webp',
      UnitBoost.transport => 'photo_transport.webp',
      UnitBoost.commander => 'photo_commander.webp',
    };

    return '$_pathToImages$photo';
  }

  @override
  BuildRestriction? _getFooterRestriction() => widget.cardInfo.buildRestriction;

  @override
  BuildPossibility _getBuildPossibility() => widget.cardInfo;

  @override
  BuildRestrictionPanelPolicy _getBuildRestrictionPanelPolicy() => BuildRestrictionPanelPolicy.hideTheLastIfOk;
}
