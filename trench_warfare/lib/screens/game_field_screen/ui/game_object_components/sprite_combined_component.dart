part of game_field_components;

class SpriteCombinedComponent extends SpriteComponent {
  final Iterable<Sprite?> additionalSprites;

  SpriteCombinedComponent({
    super.size,
    super.sprite,
    super.anchor,
    required this.additionalSprites,
  });

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    for (final additionalSprite in additionalSprites) {
      additionalSprite?.render(
        canvas,
        size: size,
        overridePaint: paint,
      );
    }
  }
}
