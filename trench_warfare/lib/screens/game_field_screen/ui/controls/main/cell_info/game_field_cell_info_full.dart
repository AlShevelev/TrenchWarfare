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

class GameFieldCellInfoFull extends StatelessWidget {
  final GameFieldControlsCellInfo cellInfo;

  late final TextureAtlas _spritesAtlas;

  GameFieldCellInfoFull({
    super.key,
    required this.cellInfo,
    required TextureAtlas spritesAtlas
  }) {
    _spritesAtlas = spritesAtlas;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GameFieldCellInfoTitle(
              cellInfo: cellInfo,
            ),
            MoneyPanel(money: cellInfo.income, smallFont: true, stretch: false,),
          ],
        ),
        Expanded(
          child: CustomPaint(
            painter: GameFieldCellInfoGameObjectPainter(cellInfo, _spritesAtlas),
            child: Container(
              child: null,
            ),
          ),
        ),
      ],
    );
  }
}
