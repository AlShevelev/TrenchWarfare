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

class GameFieldCellInfoPcOrTerrainModifier extends StatelessWidget {
  final GameFieldControlsCellInfo cellInfo;

  final TextureAtlas _spritesAtlas;

  static const _width = 182.0;
  static const _height = 83.0;

  final double _left;
  final double _top;

  final String _backgroundPath;

  const GameFieldCellInfoPcOrTerrainModifier({
    super.key,
    required this.cellInfo,
    required TextureAtlas spritesAtlas,
    required double left,
    required double top,
    required String backgroundPath,
  })  : _spritesAtlas = spritesAtlas,
        _left = left,
        _top = top,
        _backgroundPath = backgroundPath;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _left,
      top: _top,
      width: _width,
      height: _height,
      child: Background(
          imagePath: '${_backgroundPath}panel_cell_info.webp',
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 14, 8, 14),
            child: DefaultTextStyle(
              style: AppTypography.s20w600,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GameFieldCellInfoTitle(
                        cellInfo: cellInfo,
                      ),
                      MoneyPanel(
                        money: cellInfo.income,
                        smallFont: true,
                        stretch: false,
                      ),
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
              ),
            ),
          )),
    );
  }
}
