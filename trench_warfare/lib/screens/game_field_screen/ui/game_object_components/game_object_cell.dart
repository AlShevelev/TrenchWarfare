part of game_field_components;

final class GameObjectCell extends GameObjectComponentBase with Snapshot {
  final GameFieldCell _cell;

  final GameFieldRead _gameField;

  GameObjectCell(
    TextureAtlas spritesAtlas,
    GameFieldCell cell,
    bool isHuman,
    GameFieldRead gameField,
  )   : _cell = cell,
        _gameField = gameField,
        super(spritesAtlas: spritesAtlas, position: cell.center, isHuman: isHuman);

  @override
  void _addChildComponents() {
    final root = SnapshotComponent();
    add(root);

    _addTerrainModifierSprites(root);
    _addProductionCenterSprites(root);
    _addUnitsSprites(root);
    _addNationBannerSprites(root);

    if (_isHuman) {
      _addPathSprites(root);
    }

    if (GameCellBorder.isNotEmpty(_cell, _gameField)) {
      final border = GameCellBorder(_cell, _gameField)..priority = -1000;
      root.add(border);
    }
  }

  void _addTerrainModifierSprites(PositionComponent root) {
    final terrainModifier = _cell.terrainModifier;

    if (terrainModifier == null) {
      return;
    }

    final name = SpriteAtlasNames.getTerrainModifier(terrainModifier.type);

    _addSprite(name, root: root);
  }

  void _addProductionCenterSprites(PositionComponent root) {
    final productionCenter = _cell.productionCenter;

    if (productionCenter == null) {
      return;
    }

    final bodyName = SpriteAtlasNames.getProductionCenter(productionCenter);

    final levelName = SpriteAtlasNames.getProductionCenterLevel(productionCenter);

    _addCombinedSprite([bodyName, levelName], root: root);
    _addText(productionCenter.name, root);
  }

  void _addUnitsSprites(PositionComponent root) {
    if (_cell.units.isEmpty) {
      return;
    }

    _addUnitSprites(
      unit: _cell.activeUnit!,
      nation: _cell.nation,
      unitsTotal: _cell.units.length,
      root: root,
    );
  }

  void _addNationBannerSprites(PositionComponent root) {
    if (_cell.isEmpty) {
      return;
    }

    _addSprite(SpriteAtlasNames.getNationBanner(_cell.nation!), root: root);
  }

  void _addPathSprites(PositionComponent root) {
    final pathItem = _cell.pathItem;

    if (pathItem == null) {
      return;
    }

    final pathSprite = SpriteAtlasNames.getPath(pathItem.type);

    _addSprite(pathSprite, decorator: pathItem.isActive ? null : _getDisabledDecorator(), root: root);
  }

  void _addText(String? text, PositionComponent? root) {
    if (text == null || text.isEmpty) {
      return;
    }

    const style = TextStyle(
      color: AppColors.white,
      fontSize: 16.0,
      fontStyle: FontStyle.italic,
      shadows: [
        Shadow(
          offset: Offset(1, 1),
          blurRadius: 5.0,
        )
      ],
    );
    final regular = TextPaint(style: style);

    TextComponent textComponent = TextComponent(
      text: text,
      textRenderer: regular,
    )
      ..anchor = Anchor.topCenter
      ..position = Vector2(0, ComponentConstants.cellRealSize.y * 0.3)
      ..priority = 2;

    (root ?? this).add(textComponent);
  }
}
