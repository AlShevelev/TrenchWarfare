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
  void onLoad() {
    super.onLoad();
    _addChildObjects();
  }

  @protected
  void _addChildObjects() {}

  @protected
  void _addUnitSprites({
    required Unit unit,
    required Nation? nation,
    required int? unitsTotal,
    bool alwaysEnabled = false,
    Component? root,
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
    if (state == UnitState.disabled) {
      _addSprite(
        primaryUnitName,
        decorator: _getDisabledDecorator(),
        size: _SpriteSize.base,
        root: root,
      );
      _addSprite(
        secondaryUnitName,
        decorator: _getDisabledDecorator(),
        size: _SpriteSize.base,
        root: root,
      );
    } else {
      if (state == UnitState.active && _isHuman) {
        _addSprite(
          SpriteAtlasNames.getSelectionFrame(),
          size: _SpriteSize.base,
          root: root,
        );
      }

      _addSprite(
        primaryUnitName,
        size: _SpriteSize.base,
        root: root,
      );
      _addSprite(
        secondaryUnitName,
        size: _SpriteSize.base,
        root: root,
      );
    }

    _addSprite(
      healthName,
      size: _SpriteSize.base,
      root: root,
    );
    if (quantityName != null) {
      _addSprite(
        quantityName,
        size: _SpriteSize.base,
        root: root,
      );
    }
    _addSprite(
      experienceRankName,
      size: _SpriteSize.base,
      root: root,
    );
    _addSprite(
      boost1Name,
      size: _SpriteSize.base,
      root: root,
    );
    _addSprite(
      boost2Name,
      size: _SpriteSize.base,
      root: root,
    );
    _addSprite(
      boost3Name,
      size: _SpriteSize.base,
      root: root,
    );
  }

  @protected
  void _addSprite(
    String? spriteName, {
    _SpriteSize size = _SpriteSize.small,
    Decorator? decorator,
    Component? root,
  }) {
    if (spriteName == null) {
      return;
    }

    final componentSize = switch (size) {
      _SpriteSize.small => _smallSize,
      _SpriteSize.base => _baseSize,
      _SpriteSize.large => _largeSize,
    };

    final sprite = SpriteComponent(
      size: componentSize,
      sprite: _spritesAtlas.findSpriteByName(spriteName),
      anchor: Anchor.center,
    );

    if (decorator != null) {
      sprite.decorator.addLast(decorator);
    } else {
      sprite.decorator.removeLast();
    }

    (root ?? this).add(sprite);
  }

  /// See https://docs.flame-engine.org/1.3.0/flame/rendering/decorators.html#paintdecorator-grayscale
  @protected
  Decorator _getDisabledDecorator() => PaintDecorator.tint(AppColors.halfDark);
}
