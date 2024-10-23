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
  static const _pathToImages = 'assets/images/screens/game_field/cards/troop_boosters/';

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
  String _getPhoto() => CardPhotos.getPhoto(widget.cardInfo);

  @override
  BuildRestriction? _getFooterRestriction() => widget.cardInfo.buildDisplayRestriction;

  @override
  BuildPossibility _getBuildPossibility() => widget.cardInfo;
}
