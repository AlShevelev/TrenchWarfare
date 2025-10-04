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

class GameFieldCellInfoUnits extends StatelessWidget with GameFieldArmyInfoUnitsCache {
  final GameFieldControlsCellInfo cellInfo;

  final TextureAtlas _spritesAtlas;

  GameFieldCellInfoUnits({
    super.key,
    required this.cellInfo,
    required TextureAtlas spritesAtlas,
  })  : _spritesAtlas = spritesAtlas;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        for (var i = 0; i < cellInfo.units.length; i++)
          GameFieldArmyInfoUnit(
            unit: cellInfo.units[i],
            nation: cellInfo.nation!,
            spritesAtlas: _spritesAtlas,
            cache: this,
          ),
      ],
    );
  }
}
