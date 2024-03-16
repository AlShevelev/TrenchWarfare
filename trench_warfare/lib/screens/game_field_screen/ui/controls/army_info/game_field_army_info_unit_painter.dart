part of game_field_army_info;

class GameFieldArmyInfoUnitPainter extends CustomPainter {
  late final Unit _unit;

  late final Nation _nation;

  late final TextureAtlas _spritesAtlas;

  GameFieldArmyInfoUnitPainter(Unit unit, Nation nation, TextureAtlas spritesAtlas) {
    _unit = unit;
    _nation = nation;
    _spritesAtlas = spritesAtlas;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final drawingRect = Rect.fromLTWH(0, 0, size.width, size.height);

    _draw(
      spriteName: SpriteAtlasNames.getUnitPrimary(_unit, _nation),
      canvas: canvas,
      drawingRect: drawingRect,
      decorator: _unit.state == UnitState.disabled ? _getDisabledDecorator() : null,
    );
    _draw(
      spriteName: SpriteAtlasNames.getUnitSecondary(_unit),
      canvas: canvas,
      drawingRect: drawingRect,
      decorator: _unit.state == UnitState.disabled ? _getDisabledDecorator() : null,
    );

    _drawAll(
      canvas,
      spriteNames: [
        SpriteAtlasNames.getUnitHealth(_unit),
        SpriteAtlasNames.getUnitExperienceRank(_unit),
        SpriteAtlasNames.getUnitBoost1(_unit),
        SpriteAtlasNames.getUnitBoost2(_unit),
        SpriteAtlasNames.getUnitBoost3(_unit),
      ],
      drawingRect: drawingRect,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

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
