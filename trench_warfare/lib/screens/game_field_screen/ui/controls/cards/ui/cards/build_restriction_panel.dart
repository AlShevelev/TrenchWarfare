part of card_controls;

class BuildRestrictionPanel extends StatelessWidget {
  final MoneyUnit money;

  final BuildPossibility buildPossibility;

  const BuildRestrictionPanel({
    super.key,
    required this.money,
    required this.buildPossibility,
  });

  @override
  Widget build(BuildContext context) {
    const acceptedColor = AppColors.black;
    const rejectedColor = AppColors.red;
    const textStyle = AppTypography.s18w600;

    final showLastRestriction = buildPossibility.buildError != null || buildPossibility.buildDisplayRestriction != null;

    final hasError = buildPossibility.buildError != null;

    final lastRestriction = buildPossibility.buildError ?? buildPossibility.buildDisplayRestriction;

    return Row(
      children: [
        Image.asset(
          'assets/images/screens/game_field/icon_money.webp',
          height: 18,
          color: buildPossibility.canBuildByCurrency ? acceptedColor : rejectedColor,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(2, 0, 12, 0),
          child: Text(
            money.currency < 100000 ? money.currency.toString() : tr('greater_100_k'),
            style: buildPossibility.canBuildByCurrency ? textStyle : textStyle.copyWith(color: rejectedColor),
            overflow: TextOverflow.fade,
          ),
        ),
        Image.asset(
          'assets/images/screens/game_field/icon_industry_points.webp',
          height: 18,
          color: buildPossibility.canBuildByIndustryPoint ? acceptedColor : rejectedColor,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(2, 0, 12, 0),
          child: Text(
            money.industryPoints < 100000 ? money.industryPoints.toString() : tr('greater_100_k'),
            style: buildPossibility.canBuildByIndustryPoint ? textStyle : textStyle.copyWith(color: rejectedColor),
            overflow: TextOverflow.fade,
          ),
        ),
        if (showLastRestriction)
          Image.asset(
            _getRestrictionIcon(lastRestriction!),
            height: 18,
            color: hasError ? rejectedColor : acceptedColor,
          ),
        if (showLastRestriction)
          Padding(
            padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
            child: Text(
              _getRestrictionText(lastRestriction!),
              style: hasError ? textStyle.copyWith(color: rejectedColor) : textStyle,
              overflow: TextOverflow.fade,
            ),
          ),
      ],
    );
  }

  String _getRestrictionIcon(BuildRestriction restriction) => switch (restriction) {
        ProductionCenterBuildRestriction(productionCenterType: var productionCenterType) => switch (productionCenterType) {
            ProductionCenterType.city => 'assets/images/screens/game_field/icon_city.webp',
            ProductionCenterType.factory => 'assets/images/screens/game_field/icon_factory.webp',
            ProductionCenterType.airField => 'assets/images/screens/game_field/icon_air_field.webp',
            ProductionCenterType.navalBase => 'assets/images/screens/game_field/icon_naval_base.webp',
          },
        AppropriateCell() => 'assets/images/screens/game_field/icon_cell.webp',
        AppropriateUnit() => 'assets/images/screens/game_field/icon_unit.webp',
      };

  String _getRestrictionText(BuildRestriction restriction) => switch (restriction) {
        ProductionCenterBuildRestriction(productionCenterLevel: var productionCenterLevel) => switch (productionCenterLevel) {
            ProductionCenterLevel.level1 => tr('level_1'),
            ProductionCenterLevel.level2 => tr('level_2'),
            ProductionCenterLevel.level3 => tr('level_3'),
            ProductionCenterLevel.level4 => tr('level_4'),
            ProductionCenterLevel.capital => tr('level_capital'),
          },
        AppropriateCell() => tr('no_cell_to_add'),
        AppropriateUnit() => tr('no_unit_to_add'),
      };
}
