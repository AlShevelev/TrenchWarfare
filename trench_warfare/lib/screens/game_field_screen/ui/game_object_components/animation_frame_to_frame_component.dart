part of game_field_components;

class AnimationFrameToFrameComponent extends SpriteAnimationComponent {
  /// [stepTime] in seconds
  AnimationFrameToFrameComponent({
    required Image animationAtlas,
    required double stepTime,
    required Vector2 position,
  }) : super(
          animation: SpriteSheet(image: animationAtlas, srcSize: ComponentConstants.spriteInAtlasSize)
              .createAnimation(row: 0, stepTime: stepTime),
          scale: Vector2.all(1.0),
          position: position,
          anchor: Anchor.center,
          size: ComponentConstants.cellSize,
        );
}
