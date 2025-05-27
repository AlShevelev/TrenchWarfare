/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:trench_warfare/app/theme/typography.dart';
import 'package:trench_warfare/core/entities/money/money_unit.dart';

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
          'assets/images/screens/game_field/icon_money.webp',
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
          'assets/images/screens/game_field/icon_industry_points.webp',
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