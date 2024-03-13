import 'package:flame/components.dart';
import 'package:flame_gdx_texture_packer/atlas/texture_atlas.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:trench_warfare/core_entities/entities/game_objects/game_object.dart';
import 'package:trench_warfare/core_entities/enums/terrain_modifier_type.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/game_object_components/sprite_atlas/sprite_atlas_names.dart';
import 'package:trench_warfare/screens/game_field_screen/view_model/game_field_controls_state.dart';

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
    return Rect.fromLTWH((size.width - sideSize) / 2, (size.height - sideSize) / 2, sideSize, sideSize);
  }
}
