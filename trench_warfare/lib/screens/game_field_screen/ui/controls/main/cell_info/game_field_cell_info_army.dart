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

class GameFieldCellInfoArmy extends StatelessWidget implements GameFieldArmyInfoUnitsCache {
  final Map<String, Picture> _cachedUnitPictures = {};

  final GameFieldControlsCellInfo cellInfo;

  final TextureAtlas _spritesAtlas;

  static const _width = 280.0;
  static const _height = 133.0;

  final double _left;
  final double _top;

  final String _backgroundPath;

  GameFieldCellInfoArmy({
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
          imagePath: '${_backgroundPath}panel_cell_info_army.webp',
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 14, 8, 14),
            child: DefaultTextStyle(
              style: AppTypography.s20w600,
              child: Column(
                children: [
                  Row(
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
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                    child: Row(
                      children: <Widget>[
                        for (var i = 0; i < cellInfo.units.length; i++)
                          GameFieldArmyInfoUnit(
                            unit: cellInfo.units[i],
                            nation: cellInfo.nation!,
                            spritesAtlas: _spritesAtlas,
                            cache: this,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  @override
  Picture? getUnitPicture(String key) => _cachedUnitPictures[key];

  @override
  void putUnitPicture(String key, Picture picture) => _cachedUnitPictures.addAll({key: picture});
}
