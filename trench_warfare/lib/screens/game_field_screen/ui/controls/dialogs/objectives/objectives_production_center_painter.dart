import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flame_gdx_texture_packer/atlas/texture_atlas.dart';
import 'package:flutter/widgets.dart';
import 'package:trench_warfare/core/entities/game_objects/game_object_library.dart';
import 'package:trench_warfare/core/enums/production_center_level.dart';
import 'package:trench_warfare/core/enums/production_center_type.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/game_object_components/sprite_atlas/sprite_atlas_names.dart';

class ObjectivesProductionCenterPainter extends CustomPainter {
  late final ProductionCenterType _type;

  late final ProductionCenterLevel _level;

  late final TextureAtlas _spritesAtlas;

  ObjectivesProductionCenterPainter({
    required ProductionCenterType type,
    required ProductionCenterLevel level,
    required TextureAtlas spritesAtlas,
  })  : _type = type,
        _level = level,
        _spritesAtlas = spritesAtlas;

  @override
  void paint(Canvas canvas, Size size) {
    final cachedPicture = _getPicture(size);
    canvas.drawPicture(cachedPicture);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  Picture _getPicture(Size size) {
    final drawingRect = Rect.fromLTWH(0, 0, size.width, size.height);

    final recorder = PictureRecorder();
    final picCanvas = Canvas(recorder, drawingRect);

    final productionCenter = ProductionCenter(
      type: _type,
      level: _level,
      name: {},
    );

    _draw(
      spriteName: SpriteAtlasNames.getProductionCenter(productionCenter),
      canvas: picCanvas,
      drawingRect: drawingRect,
    );

    _draw(
      spriteName: SpriteAtlasNames.getProductionCenterLevel(productionCenter),
      canvas: picCanvas,
      drawingRect: drawingRect,
    );

    return recorder.endRecording();
  }

  void _draw({String? spriteName, required Canvas canvas, required Rect drawingRect}) {
    if (spriteName == null) {
      return;
    }

    final sprite = _spritesAtlas.findSpriteByName(spriteName);

    if (sprite != null) {
      sprite.render(
        canvas,
        position: Vector2(drawingRect.left, drawingRect.top),
        size: Vector2(drawingRect.width, drawingRect.height),
      );
    }
  }
}
