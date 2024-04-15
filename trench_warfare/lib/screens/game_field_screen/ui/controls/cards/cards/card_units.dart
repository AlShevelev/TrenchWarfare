part of card_controls;

class CardUnits extends CardBase {
  final GameFieldControlsUnitCard unit;

  CardUnits({
    super.key,
    required this.unit,
    required super.selected,
    required super.index,
    required super.onClick,
  });

  @override
  State<StatefulWidget> createState() => _CardUnitsState();
}

class _CardUnitsState extends CardBaseState<CardUnits> {
  static const _unitsPath = 'assets/images/game_field_overlays/cards/units/';

  @override
  String _getDescriptionText() => switch (widget.unit.type) {
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
  MoneyUnit _getFooterMoney() => widget.unit.cost;

  @override
  String _getTitleText() => switch (widget.unit.type) {
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
  String getBackgroundImage() => '${_unitsPath}card_background.webp';

  @override
  Widget _getFeaturesPanel() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _getFeature(widget.unit.maxHealth.toString(), '${_unitsPath}icon_health.webp'),
          _getFeature(widget.unit.attack.toString(), '${_unitsPath}icon_attack.webp'),
          _getFeature(widget.unit.defence.toString(), '${_unitsPath}icon_defence.webp'),
          _getFeature('${widget.unit.damage.min}-${widget.unit.damage.max}', '${_unitsPath}icon_damage.webp'),
          _getFeature(widget.unit.movementPoints.toInt().toString(), '${_unitsPath}icon_speed.webp'),
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
  String _getPhoto() {
    final photo = switch (widget.unit.type) {
      UnitType.armoredCar => 'photo_armored_car.webp',
      UnitType.artillery => 'photo_artillery.webp',
      UnitType.infantry => 'photo_infantry.webp',
      UnitType.cavalry => 'photo_cavalry.webp',
      UnitType.machineGunnersCart => 'photo_machine_gunners_cart.webp',
      UnitType.machineGuns => 'photo_machine_gunners.webp',
      UnitType.tank => 'photo_tank.webp',
      UnitType.destroyer => 'photo_destroyer.webp',
      UnitType.cruiser => 'photo_cruiser.webp',
      UnitType.battleship => 'photo_battleship.webp',
      UnitType.carrier => 'photo_carrier.webp',
    };

    return '$_unitsPath$photo';
  }

  @override
  BuildRestriction? _getFooterRestriction() => widget.unit.buildRestriction;

  @override
  BuildPossibility _getBuildPossibility() => widget.unit;
}
