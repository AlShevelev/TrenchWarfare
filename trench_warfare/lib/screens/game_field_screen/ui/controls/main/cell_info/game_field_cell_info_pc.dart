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

class GameFieldCellInfoPc extends StatelessWidget
    with GameFieldArmyInfoUnitsCache {

  final GameFieldControlsCellInfo cellInfo;

  final TexturePackerAtlas _spritesAtlas;

  GameFieldCellInfoPc({
    super.key,
    required this.cellInfo,
    required TexturePackerAtlas spritesAtlas,
  })  : _spritesAtlas = spritesAtlas;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: GameFieldCellInfoGameObjectPainter(cellInfo, _spritesAtlas),
      child: const SizedBox(
        width: 60,
        height: 60,
        child: null,
      ),
    );
  }
}
