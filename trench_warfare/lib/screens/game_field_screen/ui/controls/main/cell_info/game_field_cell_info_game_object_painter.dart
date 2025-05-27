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

class GameFieldCellInfoGameObjectPainter extends CustomPainter {
  late final GameFieldControlsCellInfo _cellInfo;

  late final TextureAtlas _spritesAtlas;

  GameFieldCellInfoGameObjectPainter(GameFieldControlsCellInfo cellInfo, TextureAtlas spritesAtlas) {
    _cellInfo = cellInfo;
    _spritesAtlas = spritesAtlas;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (_cellInfo.terrainModifier != null) {
      _drawTerrainModifier(canvas, size, _cellInfo.terrainModifier!);
    } else if (_cellInfo.productionCenter != null) {
      _drawProductionCenter(canvas, size, _cellInfo.productionCenter!);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  void _drawTerrainModifier(Canvas canvas, Size size, TerrainModifierType terrainModifier) {
    _draw(
      SpriteAtlasNames.getTerrainModifier(terrainModifier),
      canvas,
      _calculateDrawingRect(size),
    );
  }

  void _drawProductionCenter(Canvas canvas, Size size, ProductionCenter productionCenter) {
    final drawingRect = _calculateDrawingRect(size);

    _draw(
      SpriteAtlasNames.getProductionCenter(productionCenter),
      canvas,
      drawingRect,
    );

    _draw(
      SpriteAtlasNames.getProductionCenterLevel(productionCenter),
      canvas,
      drawingRect,
    );
  }

  void _draw(String spriteName, Canvas canvas, Rect drawingRect) {
    final sprite = _spritesAtlas.findSpriteByName(spriteName);

    if (sprite != null) {
      sprite.render(
        canvas,
        position: Vector2(drawingRect.left, drawingRect.top),
        size: Vector2(drawingRect.width, drawingRect.height),
      );
    }
  }

  /// Calculates the square drawing rect
  Rect _calculateDrawingRect(Size size) {
    if (size.width == size.height) {
      return Rect.fromLTWH(0, 0, size.width, size.height);
    }

    final sideSize = size.width > size.height ? size.height : size.width;
    return Rect.fromLTWH(size.width - sideSize, (size.height - sideSize) / 2, sideSize, sideSize);
  }
}
