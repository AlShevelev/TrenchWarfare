part of game_field_army_info;

class GameFieldArmyInfoUnitPainter extends CustomPainter {
  late final Unit _unit;

  late final Nation _nation;

  late final TextureAtlas _spritesAtlas;

  late final GameFieldArmyInfoUnitsCache _cache;

  GameFieldArmyInfoUnitPainter({
    required Unit unit,
    required Nation nation,
    required TextureAtlas spritesAtlas,
    required GameFieldArmyInfoUnitsCache cache,
  }) {
    _unit = unit;
    _nation = nation;
    _spritesAtlas = spritesAtlas;
    _cache = cache;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var cachedPicture = _cache.getUnitPicture(_unit.id);

    if (cachedPicture != null) {
      canvas.drawPicture(cachedPicture);
      return;
    }

    cachedPicture = _drawPicture(size);
    _cache.putUnitPicture(_unit.id, cachedPicture);

    canvas.drawPicture(cachedPicture);
  }

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
      decorator: _unit.state == UnitState.disabled ? _getDisabledDecorator() : null,
    );
    _draw(
      spriteName: SpriteAtlasNames.getUnitSecondary(_unit),
      canvas: picCanvas,
      drawingRect: drawingRect,
      decorator: _unit.state == UnitState.disabled ? _getDisabledDecorator() : null,
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
      _draw(spriteName: s, canvas: canvas, drawingRect: drawingRect, decorator: null);
    }
  }

  void _draw({String? spriteName, required Canvas canvas, required Rect drawingRect, Decorator? decorator}) {
    if (spriteName == null) {
      return;
    }

    final sprite = _spritesAtlas.findSpriteByName(spriteName);

    if (sprite != null) {
      if (decorator != null) {
        sprite.decorator.addLast(decorator);
      } else {
        sprite.decorator.removeLast();
      }

      sprite.render(
        canvas,
        position: Vector2(drawingRect.left, drawingRect.top),
        size: Vector2(drawingRect.width, drawingRect.height),
      );
    }
  }

  Decorator _getDisabledDecorator() => PaintDecorator.tint(AppColors.halfDark);
}
