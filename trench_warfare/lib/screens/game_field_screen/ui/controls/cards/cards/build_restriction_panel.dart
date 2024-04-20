part of card_controls;

enum BuildRestrictionPanelPolicy {
  alwaysShowTheLast,
  hideTheLastIfOk,
}

class BuildRestrictionPanel extends StatelessWidget {
  final MoneyUnit money;

  final BuildRestriction? restriction;

  final BuildPossibility buildPossibility;

  final BuildRestrictionPanelPolicy policy;

  const BuildRestrictionPanel({
    super.key,
    required this.money,
    required this.restriction,
    required this.buildPossibility,
    required this.policy,
  });

  @override
  Widget build(BuildContext context) {
    const acceptedColor = AppColors.black;
    const rejectedColor = AppColors.darkRed;
    const textStyle = AppTypography.s18w600;

    final showLastRestriction = restriction != null &&
        (policy == BuildRestrictionPanelPolicy.alwaysShowTheLast ||
            (policy == BuildRestrictionPanelPolicy.hideTheLastIfOk && !buildPossibility.canBuildOnGameField));

    return Row(
      children: [
        Image.asset(
          'assets/images/game_field_overlays/icon_money.webp',
          height: 18,
          color: buildPossibility.canBuildByCurrency ? acceptedColor : rejectedColor,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(2, 0, 12, 0),
          child: Text(
            money.currency < 10000 ? money.currency.toString() : tr('greater_10_k'),
            style: buildPossibility.canBuildByCurrency ? textStyle : textStyle.copyWith(color: rejectedColor),
            overflow: TextOverflow.fade,
          ),
        ),
        Image.asset(
          'assets/images/game_field_overlays/icon_industry_points.webp',
          height: 18,
          color: buildPossibility.canBuildByIndustryPoint ? acceptedColor : rejectedColor,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(2, 0, 12, 0),
          child: Text(
            money.industryPoints < 10000 ? money.industryPoints.toString() : tr('greater_10_k'),
            style: buildPossibility.canBuildByIndustryPoint ? textStyle : textStyle.copyWith(color: rejectedColor),
            overflow: TextOverflow.fade,
          ),
        ),
        if (showLastRestriction)
          Image.asset(
            _getRestrictionIcon(),
            height: 18,
            color: buildPossibility.canBuildOnGameField ? acceptedColor : rejectedColor,
          ),
        if (showLastRestriction)
          Padding(
            padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
            child: Text(
              _getRestrictionText(),
              style: buildPossibility.canBuildOnGameField ? textStyle : textStyle.copyWith(color: rejectedColor),
              overflow: TextOverflow.fade,
            ),
          ),
      ],
    );
  }

  String _getRestrictionIcon() => switch (restriction) {
        UnitBuildRestriction(productionCenterType: var productionCenterType) => switch (productionCenterType) {
            ProductionCenterType.city => 'assets/images/game_field_overlays/icon_city.webp',
            ProductionCenterType.factory => 'assets/images/game_field_overlays/icon_factory.webp',
            ProductionCenterType.airField => 'assets/images/game_field_overlays/icon_air_field.webp',
            ProductionCenterType.navalBase => 'assets/images/game_field_overlays/icon_naval_base.webp',
          },
        AppropriateCell() => 'assets/images/game_field_overlays/icon_cell.webp',
        AppropriateUnit() => 'assets/images/game_field_overlays/icon_unit.webp',
        _ => throw UnsupportedError(''),
      };

  String _getRestrictionText() => switch (restriction) {
        UnitBuildRestriction(productionCenterLevel: var productionCenterLevel) => switch (productionCenterLevel) {
            ProductionCenterLevel.level1 => tr('level_1'),
            ProductionCenterLevel.level2 => tr('level_2'),
            ProductionCenterLevel.level3 => tr('level_3'),
            ProductionCenterLevel.level4 => tr('level_4'),
            ProductionCenterLevel.capital => tr('level_capital'),
          },
        AppropriateCell() => tr('no_cell_to_add'),
        AppropriateUnit() => tr('no_unit_to_add'),
        _ => throw UnsupportedError(''),
      };
}
