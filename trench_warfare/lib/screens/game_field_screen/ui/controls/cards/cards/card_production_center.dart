part of card_controls;

class CardProductionCenter extends CardBase {
  final GameFieldControlsProductionCentersCard cardInfo;

  CardProductionCenter({
    super.key,
    required this.cardInfo,
    required super.selected,
    required super.index,
    required super.onClick,
  });

  @override
  State<StatefulWidget> createState() => _CardProductionCenterState();
}

class _CardProductionCenterState extends CardBaseState<CardProductionCenter> {
  static const _pathToImages = 'assets/images/game_field_overlays/cards/production_centers/';

  @override
  String _getDescriptionText() => switch (widget.cardInfo.type) {
    ProductionCenterType.city => tr('city_card_description'),
    ProductionCenterType.factory => tr('factory_card_description'),
    ProductionCenterType.airField => tr('air_field_card_description'),
    ProductionCenterType.navalBase => tr('naval_base_card_description'),
  };

  @override
  MoneyUnit _getFooterMoney() => widget.cardInfo.cost;

  @override
  String _getTitleText() => switch (widget.cardInfo.type) {
    ProductionCenterType.city => tr('city_card_name'),
    ProductionCenterType.factory => tr('factory_card_name'),
    ProductionCenterType.airField => tr('air_field_card_name'),
    ProductionCenterType.navalBase => tr('naval_base_card_name'),
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
