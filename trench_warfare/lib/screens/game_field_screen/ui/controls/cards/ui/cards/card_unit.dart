part of card_controls;

class _CardUnit extends _CardBase<UnitType> {
  static const _pathToImages = 'assets/images/screens/game_field/cards/units/';

  const _CardUnit({
    super.key,
    required super.card,
    required super.userActions,
  });

  @override
  String _getDescriptionText() => switch (_card.card.type) {
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
  MoneyUnit _getFooterMoney() => _card.card.cost;

  @override
  String _getTitleText() => switch (_card.card.type) {
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
  String getBackgroundImage() => 'assets/images/screens/shared/card_red_background.webp';

  @override
  Widget _getFeaturesPanel() {
    final card = _card.card as GameFieldControlsUnitCard;

    return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      _getFeature(card.maxHealth.toString(), '${_pathToImages}icon_health.webp'),
      _getFeature(card.attack.toString(), '${_pathToImages}icon_attack.webp'),
      _getFeature(card.defence.toString(), '${_pathToImages}icon_defence.webp'),
      _getFeature('${card.damage.min}-${card.damage.max}', '${_pathToImages}icon_damage.webp'),
      _getFeature(card.movementPoints.toInt().toString(), '${_pathToImages}icon_speed.webp'),
    ],
  );
  }

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
}
