/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of game_field_components;

class AnimationFrameToFrameComponent extends SpriteAnimationComponent {
  /// [stepTime] in seconds
  AnimationFrameToFrameComponent({
    required Image animationAtlas,
    required double totalTimeInSeconds,
    required Range<int> frames,
    required Vector2 position,
  }) : super(
          animation: SpriteSheet(image: animationAtlas, srcSize: ComponentConstants.spriteInAtlasSize)
              .createAnimation(
            row: 0,
            stepTime: totalTimeInSeconds / (frames.max - frames.min + 1),
            from: frames.min,
            to: frames.max
          ),
          scale: Vector2.all(1.0),
          position: position,
          anchor: Anchor.center,
          size: ComponentConstants.cellSize,
        );
}
