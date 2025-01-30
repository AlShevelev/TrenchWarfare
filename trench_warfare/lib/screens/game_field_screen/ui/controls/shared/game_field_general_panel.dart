import 'package:flutter/material.dart';
import 'package:trench_warfare/app/theme/colors.dart';
import 'package:trench_warfare/core/entities/money/money_unit.dart';
import 'package:trench_warfare/core/enums/nation.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/shared/money_panel.dart';

class GameFieldGeneralPanel extends StatelessWidget {
  static const _width = 218.0;
  static const _height = 30.0;
  static const _bannerSize = 20.0;

  final MoneyUnit _money;

  final Nation _nation;

  final double _left;
  final double _top;

  const GameFieldGeneralPanel({
    super.key,
    required MoneyUnit money,
    required Nation nation,
    required double left,
    required double top,
  })  : _money = money,
        _nation = nation,
        _left = left,
        _top = top;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _left,
      top: _top,
      width: _width,
      height: _height,
      child: Material(
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.black.withAlpha(100),
            image: const DecorationImage(
              image: AssetImage("assets/images/screens/game_field/main/panel_general_info.webp"),
              fit: BoxFit.fill,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
                  child: Image.asset(
                    _getBanner(),
                    width: _bannerSize,
                    height: _bannerSize,
                  ),
                ),
                Expanded(
                  child: MoneyPanel(
                    money: _money,
                    smallFont: false,
                    stretch: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getBanner() => 'assets/images/screens/game_field/banners/${_nation.name}.webp';
}
