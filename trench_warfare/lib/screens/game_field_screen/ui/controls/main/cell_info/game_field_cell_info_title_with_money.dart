/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of game_field_cell_info;

class GameFieldCellInfoTitleWithMoney extends StatelessWidget {
  final GameFieldControlsCellInfo cellInfo;

  const GameFieldCellInfoTitleWithMoney({
    super.key,
    required this.cellInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GameFieldCellInfoTitle(
          cellInfo: cellInfo,
        ),
        MoneyPanel(
          money: cellInfo.income,
          smallFont: false,
          stretch: false,
        ),
      ],
    );
  }
}
