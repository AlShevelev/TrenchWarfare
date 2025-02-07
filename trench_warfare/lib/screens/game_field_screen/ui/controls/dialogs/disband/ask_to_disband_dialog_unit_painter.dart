import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flame_gdx_texture_packer/atlas/texture_atlas.dart';
import 'package:flutter/widgets.dart';
import 'package:trench_warfare/core/entities/game_objects/game_object_library.dart';
import 'package:trench_warfare/core/enums/nation.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/game_object_components/sprite_atlas/sprite_atlas_names.dart';

class AskToDisbandDialogUnitPainter extends CustomPainter {
  final Unit _unit;

  final Nation _nation;

  final TextureAtlas _spritesAtlas;

  AskToDisbandDialogUnitPainter({
    required Unit unit,
    required Nation nation,
    required TextureAtlas spritesAtlas,
  }) :
    _unit = unit,
    _nation = nation,
    _spritesAtlas = spritesAtlas;

  @override
  void paint(Canvas canvas, Size size) => canvas.drawPicture(_drawPicture(size));

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  Picture _drawPicture(Size size) {
    final drawingRect = Rect.fromLTWH(0, 0, size.width, size.height);

    final recorder = PictureRecorder();
    final picCanvas = Canvas(recorder, drawingRect);

    _draw(
      spriteName: SpriteAtlasNames.getUnitPrimary(_unit, _nation),
      canvas: picCanvas,
      drawingRect: drawingRect,
    );
    _draw(
      spriteName: SpriteAtlasNames.getUnitSecondary(_unit),
      canvas: picCanvas,
      drawingRect: drawingRect,
    );

    _drawAll(
      picCanvas,
      spriteNames: [
        SpriteAtlasNames.getUnitHealth(_unit),
        SpriteAtlasNames.getUnitExperienceRank(_unit),
        SpriteAtlasNames.getUnitBoost1(_unit),
        SpriteAtlasNames.getUnitBoost2(_unit),
        SpriteAtlasNames.getUnitBoost3(_unit),
      ],
      drawingRect: drawingRect,
    );

    return recorder.endRecording();
  }

  void _drawAll(Canvas canvas, {required List<String?> spriteNames, required Rect drawingRect}) {
    for (var s in spriteNames) {
      _draw(spriteName: s, canvas: canvas, drawingRect: drawingRect);
    }
  }

  void _draw({String? spriteName, required Canvas canvas, required Rect drawingRect}) {
    if (spriteName == null) {
      return;
    }

    final sprite = _spritesAtlas.findSpriteByName(spriteName);

    if (sprite != null) {
      sprite.decorator.removeLast();

      sprite.render(
        canvas,
        position: Vector2(drawingRect.left, drawingRect.top),
        size: Vector2(drawingRect.width, drawingRect.height),
      );
    }
  }
}
