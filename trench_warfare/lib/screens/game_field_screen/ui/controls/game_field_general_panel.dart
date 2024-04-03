import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:trench_warfare/app/theme/colors.dart';
import 'package:trench_warfare/app/theme/typography.dart';

class GameFieldGeneralPanel extends StatelessWidget {
  static const _width = 162.0;
  static const _height = 30.0;

  final int money;
  final int industryPoints;

  final double left;
  final double top;

  const GameFieldGeneralPanel({
    super.key,
    required this.money,
    required this.industryPoints,
    required this.left,
    required this.top,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      width: _width,
      height: _height,
      child: Material(
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.black.withAlpha(100),
            image: const DecorationImage(
              image: AssetImage("assets/images/game_field_overlays/main/panel_general_info.webp"),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/game_field_overlays/icon_money.webp',
                  height: 18,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
                  child: Text(
                    money < 10000 ? money.toString() : tr('greater_10_k'),
                    style: AppTypography.s20w600,
                    overflow: TextOverflow.fade,
                  ),
                ),
                const Spacer(),
                Image.asset(
                  'assets/images/game_field_overlays/icon_industry_points.webp',
                  height: 18,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
                  child: Text(
                      industryPoints < 10000 ? industryPoints.toString() : tr('greater_10_k'),
                    style: AppTypography.s20w600,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
