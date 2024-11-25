part of game_field_components;

final class GameObjectCell extends GameObjectComponentBase {
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

  static bool needToDrawCell(GameFieldCell cell, GameFieldRead gameField) {
    if (!cell.isEmpty || cell.pathItem != null) {
      return true;
    }

    return GameCellBorder.needToDrawBorders(cell, gameField);
  }

  @override
  void _addChildObjects() {
    final root = SnapshotComponent();
    add(root);

    _addTerrainModifierSprites(root: root);
    _addProductionCenterSprites(root: root);
    _addUnitsSprites(root: root);
    _addNationBannerSprites(root: root);

    if (_isHuman) {
      _addPathSprites(root: root);
    }

    _addBorder(root: root);
  }

  void _addTerrainModifierSprites({Component? root}) {
    final terrainModifier = _cell.terrainModifier;

    if (terrainModifier == null) {
      return;
    }

    final name = SpriteAtlasNames.getTerrainModifier(terrainModifier.type);

    _addSprite(name, root: root);
  }

  void _addProductionCenterSprites({Component? root}) {
    final productionCenter = _cell.productionCenter;

    if (productionCenter == null) {
      return;
    }

    final bodyName = SpriteAtlasNames.getProductionCenter(productionCenter);

    final levelName = SpriteAtlasNames.getProductionCenterLevel(productionCenter);

    _addSprite(bodyName, root: root);
    _addSprite(levelName, root: root);
    _addText(productionCenter.name, root: root);
  }

  void _addUnitsSprites({Component? root}) {
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

  void _addNationBannerSprites({Component? root}) {
    if (_cell.isEmpty) {
      return;
    }

    _addSprite(SpriteAtlasNames.getNationBanner(_cell.nation!), root: root);
  }

  void _addPathSprites({Component? root}) {
    final pathItem = _cell.pathItem;

    if (pathItem == null) {
      return;
    }

    final pathSprite = SpriteAtlasNames.getPath(pathItem.type);

    _addSprite(
      pathSprite,
      decorator: pathItem.isActive ? null : _getDisabledDecorator(),
      root: root,
    );
  }

  void _addText(String? text, {Component? root}) {
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

  _addBorder({Component? root}) {
    if (!GameCellBorder.needToDrawBorders(_cell, _gameField)) {
      return;
    }

    // The low priority (-1000) moves this component to back
    final border = GameCellBorder(_cell, _gameField)..priority = -1000;
    (root ?? this).add(border);
  }
}
