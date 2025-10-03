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

  static const _width = 200.0;
  static const _height = 132.0;

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
          imagePath: '${_backgroundPath}panel_cell_info_pc.webp',
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 14, 8, 14),
            child: DefaultTextStyle(
              style: AppTypography.s20w600,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GameFieldCellInfoTitleWithMoney(
                    cellInfo: cellInfo,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomPaint(
                        painter: GameFieldCellInfoGameObjectPainter(cellInfo, _spritesAtlas),
                        child: Container(
                          child: null,
                        ),
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
