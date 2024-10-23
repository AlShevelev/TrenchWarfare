part of card_controls;

class CardSpecialStrike extends CardBase {
  final GameFieldControlsSpecialStrikesCard cardInfo;

  CardSpecialStrike({
    super.key,
    required this.cardInfo,
    required super.selected,
    required super.index,
    required super.onClick,
  });

  @override
  State<StatefulWidget> createState() => _CardSpecialStrikeState();
}

class _CardSpecialStrikeState extends CardBaseState<CardSpecialStrike> {
  static const _pathToImages = 'assets/images/screens/game_field/cards/special_strikes/';

  @override
  String _getDescriptionText() => switch (widget.cardInfo.type) {
        SpecialStrikeType.gasAttack => tr('gas_attack_card_description'),
        SpecialStrikeType.flechettes => tr('flechettes_card_description'),
        SpecialStrikeType.airBombardment => tr('air_bombing_card_description'),
        SpecialStrikeType.flameTroopers => tr('flametroopers_card_description'),
        SpecialStrikeType.propaganda => tr('propaganda_card_description'),
      };

  @override
  MoneyUnit _getFooterMoney() => widget.cardInfo.cost;

  @override
  String _getTitleText() => switch (widget.cardInfo.type) {
        SpecialStrikeType.gasAttack => tr('gas_attack_card_name'),
        SpecialStrikeType.flechettes => tr('flechettes_card_name'),
        SpecialStrikeType.airBombardment => tr('air_bombing_card_name'),
        SpecialStrikeType.flameTroopers => tr('flametroopers_card_name'),
        SpecialStrikeType.propaganda => tr('propaganda_card_name'),
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
