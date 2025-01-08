import 'package:flutter/material.dart';
import 'package:trench_warfare/app/theme/colors.dart';
import 'package:trench_warfare/core/entities/money/money_unit.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/shared/money_panel.dart';

class GameFieldGeneralPanel extends StatelessWidget {
  static const _width = 182.0;
  static const _height = 30.0;

  final MoneyUnit money;

  final double left;
  final double top;

  const GameFieldGeneralPanel({
    super.key,
    required this.money,
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
              image: AssetImage("assets/images/screens/game_field/main/panel_general_info.webp"),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: MoneyPanel(money: money, smallFont: false, stretch: true,),
          ),
        ),
      ),
    );
  }
}
