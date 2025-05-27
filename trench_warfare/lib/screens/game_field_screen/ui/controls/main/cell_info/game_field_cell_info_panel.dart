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

class GameFieldCellInfoPanel extends StatelessWidget {
  static const _width = 162.0;
  static const _height = 83.0;

  final GameFieldControlsCellInfo cellInfo;

  late final TextureAtlas _spritesAtlas;

  final double left;
  final double top;

  GameFieldCellInfoPanel({
    super.key,
    required this.cellInfo,
    required this.left,
    required this.top,
    required TextureAtlas spritesAtlas
  }) {
    _spritesAtlas = spritesAtlas;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      width: _width,
      height: _height,
      child: Background(
          imagePath: 'assets/images/screens/game_field/main/panel_cell_info.webp',
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 14, 8, 14),
            child: DefaultTextStyle(
              style: AppTypography.s20w600,
              child: cellInfo.terrainModifier == null && cellInfo.productionCenter == null
                  ? GameFieldCellInfoBrief(cellInfo: cellInfo)
                  : GameFieldCellInfoFull(cellInfo: cellInfo, spritesAtlas: _spritesAtlas,)
            ),
          )),
    );
  }
}
