import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:trench_warfare/app/theme/typography.dart';
import 'package:trench_warfare/core_entities/entities/money/money_unit.dart';

class MoneyPanel extends StatelessWidget {
  final MoneyUnit money;

  final bool smallFont;

  final bool stretch;

  const MoneyPanel({super.key, required this.money, required this.smallFont, required this.stretch});

  @override
  Widget build(BuildContext context) =>
    Row(
      children: [
        Image.asset(
          'assets/images/game_field_overlays/icon_money.webp',
          height: 18,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(2, 0, stretch ? 0 : 8, 0),
          child: Text(
            money.currency < 100000 ? money.currency.toString() : tr('greater_100_k'),
            style: smallFont ? AppTypography.s18w600 : AppTypography.s20w600,
            overflow: TextOverflow.fade,
          ),
        ),
        if (stretch)
          const Spacer(),
        Image.asset(
          'assets/images/game_field_overlays/icon_industry_points.webp',
          height: 18,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
          child: Text(
            money.industryPoints < 100000 ? money.industryPoints.toString() : tr('greater_100_k'),
            style: smallFont ? AppTypography.s18w600 : AppTypography.s20w600,
            overflow: TextOverflow.fade,
          ),
        ),
      ],
    );
}