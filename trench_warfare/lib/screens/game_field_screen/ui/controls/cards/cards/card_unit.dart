part of card_controls;

class CardUnit extends CardBase {
  final GameFieldControlsUnitCard cardInfo;

  CardUnit({
    super.key,
    required this.cardInfo,
    required super.selected,
    required super.index,
    required super.onClick,
  });

  @override
  State<StatefulWidget> createState() => _CardUnitState();
}

class _CardUnitState extends CardBaseState<CardUnit> {
  static const _pathToImages = 'assets/images/screens/game_field/cards/units/';

  @override
  String _getDescriptionText() => switch (widget.cardInfo.type) {
    UnitType.armoredCar => tr('armored_car_card_description'),
    UnitType.artillery => tr('artillery_card_description'),
    UnitType.infantry => tr('infantry_card_description'),
    UnitType.cavalry => tr('cavalry_card_description'),
    UnitType.machineGunnersCart => tr('machine_gunners_cart_card_description'),
    UnitType.machineGuns => tr('machine_gunners_card_description'),
    UnitType.tank => tr('tank_card_description'),
    UnitType.destroyer => tr('destroyer_card_description'),
    UnitType.cruiser => tr('cruiser_card_description'),
    UnitType.battleship => tr('battleship_card_description'),
    UnitType.carrier => tr('carrier_card_description'),
  };

  @override
  MoneyUnit _getFooterMoney() => widget.cardInfo.cost;

  @override
  String _getTitleText() => switch (widget.cardInfo.type) {
    UnitType.armoredCar => tr('armored_car_card_name'),
    UnitType.artillery => tr('artillery_card_name'),
    UnitType.infantry => tr('infantry_card_name'),
    UnitType.cavalry => tr('cavalry_card_name'),
    UnitType.machineGunnersCart => tr('machine_gunners_cart_card_name'),
    UnitType.machineGuns => tr('machine_gunners_card_name'),
    UnitType.tank => tr('tank_card_name'),
    UnitType.destroyer => tr('destroyer_card_name'),
    UnitType.cruiser => tr('cruiser_card_name'),
    UnitType.battleship => tr('battleship_card_name'),
    UnitType.carrier => tr('carrier_card_name'),
  };

  @override
  String getBackgroundImage() => '${_pathToImages}card_background.webp';

  @override
  Widget _getFeaturesPanel() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _getFeature(widget.cardInfo.maxHealth.toString(), '${_pathToImages}icon_health.webp'),
          _getFeature(widget.cardInfo.attack.toString(), '${_pathToImages}icon_attack.webp'),
          _getFeature(widget.cardInfo.defence.toString(), '${_pathToImages}icon_defence.webp'),
          _getFeature('${widget.cardInfo.damage.min}-${widget.cardInfo.damage.max}', '${_pathToImages}icon_damage.webp'),
          _getFeature(widget.cardInfo.movementPoints.toInt().toString(), '${_pathToImages}icon_speed.webp'),
        ],
      );

  Widget _getFeature(String text, String icon) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Image.asset(
          icon,
          scale: 1.15,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: AppTypography.s22w600.fontSize,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 3
              ..color = AppColors.black,
          ),
        ),
        // Solid text as fill.
        Text(
          text,
          style: TextStyle(
            fontSize: AppTypography.s22w600.fontSize,
            color: AppColors.white,
          ),
        ),
      ],
    );
  }


  @override
  String _getPhoto() => CardPhotos.getPhoto(widget.cardInfo);

  @override
  BuildRestriction? _getFooterRestriction() => widget.cardInfo.buildDisplayRestriction;

  @override
  BuildPossibility _getBuildPossibility() => widget.cardInfo;
}
