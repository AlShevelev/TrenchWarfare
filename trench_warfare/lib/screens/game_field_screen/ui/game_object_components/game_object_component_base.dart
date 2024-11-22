part of game_field_components;

enum _SpriteSize {
  small,
  base,
  large,
}

abstract base class GameObjectComponentBase extends PositionComponent {
  @protected
  late final Vector2 _baseSize;
  @protected
  final TextureAtlas _spritesAtlas;
  @protected
  final Vector2 _position;

  @protected
  late final Vector2 _smallSize;
  @protected
  late final Vector2 _largeSize;

  final bool _isHuman;

  GameObjectComponentBase({
    required TextureAtlas spritesAtlas,
    required Vector2 position,
    required bool isHuman,
  })  : _spritesAtlas = spritesAtlas,
        _position = position,
        _isHuman = isHuman {
    this.position = position;
    _baseSize = ComponentConstants.cellSize;
    _smallSize = _baseSize.scaled(0.85);
    _largeSize = _baseSize.scaled(1.15);
  }

  @override
  @mustCallSuper
  void onMount() {
    super.onMount();
    _addSprites();
  }

  @protected
  void _addSprites() {}

  @protected
  void _addUnitSprites({
    required Unit unit,
    required Nation? nation,
    required int? unitsTotal,
    bool alwaysEnabled = false,
  }) {
    final quantityName = SpriteAtlasNames.getUnitQuantity(unitsTotal);

    final healthName = SpriteAtlasNames.getUnitHealth(unit);

    final experienceRankName = SpriteAtlasNames.getUnitExperienceRank(unit);

    final boost1Name = SpriteAtlasNames.getUnitBoost1(unit);
    final boost2Name = SpriteAtlasNames.getUnitBoost2(unit);
    final boost3Name = SpriteAtlasNames.getUnitBoost3(unit);

    final secondaryUnitName = SpriteAtlasNames.getUnitSecondary(unit);
    final primaryUnitName = SpriteAtlasNames.getUnitPrimary(unit, nation);

    final state = alwaysEnabled ? UnitState.enabled : unit.state;

    final combinedSpriteNames = <String?>[];

    if (state == UnitState.disabled) {
      _addCombinedSprite(
        [primaryUnitName, secondaryUnitName],
        decorator: _getDisabledDecorator(),
        size: _SpriteSize.base,
      );
    } else {
      if (state == UnitState.active && _isHuman) {
        combinedSpriteNames.add(SpriteAtlasNames.getSelectionFrame());
      }

      combinedSpriteNames.add(primaryUnitName);
      combinedSpriteNames.add(secondaryUnitName);
    }

    combinedSpriteNames.add(healthName);

    if (quantityName != null) {
      combinedSpriteNames.add(quantityName);
    }
    combinedSpriteNames.add(experienceRankName);
    combinedSpriteNames.add(boost1Name);
    combinedSpriteNames.add(boost2Name);
    combinedSpriteNames.add(boost3Name);

    _addCombinedSprite(
      combinedSpriteNames,
      size: _SpriteSize.base,
    );
  }

  @protected
  void _addSprite(
    String? spriteName, {
    _SpriteSize size = _SpriteSize.small,
    Decorator? decorator,
  }) {
    if (spriteName == null) {
      return;
    }

    final componentSize = switch (size) {
      _SpriteSize.small => _smallSize,
      _SpriteSize.base => _baseSize,
      _SpriteSize.large => _largeSize,
    };

    final spriteComponent = SpriteComponent(
      size: componentSize,
      sprite: _spritesAtlas.findSpriteByName(spriteName),
      anchor: Anchor.center,
    );

    if (decorator != null) {
      spriteComponent.decorator.addLast(decorator);
    } else {
      spriteComponent.decorator.removeLast();
    }

    add(spriteComponent);
  }

  @protected
  void _addCombinedSprite(
    Iterable<String?> spriteNames, {
    _SpriteSize size = _SpriteSize.small,
    Decorator? decorator,
  }) {
    if (spriteNames.length == 1) {
      _addSprite(spriteNames.first, size: size, decorator: decorator);
    }

    final validSpriteNames = spriteNames.where((n) => n != null).map((n) => n!).toList(growable: false);

    if (validSpriteNames.isEmpty) {
      return;
    }

    if (validSpriteNames.length == 1) {
      _addSprite(validSpriteNames.first, size: size, decorator: decorator);
    }

    final componentSize = switch (size) {
      _SpriteSize.small => _smallSize,
      _SpriteSize.base => _baseSize,
      _SpriteSize.large => _largeSize,
    };

    final additionalSprites =
        validSpriteNames.skip(1).map((n) => _spritesAtlas.findSpriteByName(n)).toList(growable: false);

    final spriteComponent = SpriteCombinedComponent(
      size: componentSize,
      sprite: _spritesAtlas.findSpriteByName(validSpriteNames.first),
      additionalSprites: additionalSprites,
      anchor: Anchor.center,
    );

    if (decorator != null) {
      spriteComponent.decorator.addLast(decorator);
    } else {
      spriteComponent.decorator.removeLast();
    }

    add(spriteComponent);
  }

  /// See https://docs.flame-engine.org/1.3.0/flame/rendering/decorators.html#paintdecorator-grayscale
  @protected
  Decorator _getDisabledDecorator() => PaintDecorator.tint(AppColors.halfDark);
}
