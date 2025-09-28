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

class GameFieldCellInfoBrief extends StatelessWidget {
  final GameFieldControlsCellInfo cellInfo;

  const GameFieldCellInfoBrief({
    super.key,
    required this.cellInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GameFieldCellInfoTitle(
          cellInfo: cellInfo,
        ),
        MoneyPanel(money: cellInfo.income, smallFont: false, stretch: true,),
      ],
    );
  }
}
