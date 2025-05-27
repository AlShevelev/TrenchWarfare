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
        Text(
          _getTerrainName(cellInfo.terrain),
          overflow: TextOverflow.fade,
        ),
        MoneyPanel(money: cellInfo.income, smallFont: false, stretch: true,),
      ],
    );
  }

  String _getTerrainName(CellTerrain terrain) {
    return switch (terrain) {
      CellTerrain.plain => tr('plain'),
      CellTerrain.wood => tr('wood'),
      CellTerrain.marsh => tr('marsh'),
      CellTerrain.sand => tr('sand'),
      CellTerrain.hills => tr('hills'),
      CellTerrain.mountains => tr('mountains'),
      CellTerrain.snow => tr('snow'),
      CellTerrain.water => tr('water'),
    };
  }
}
