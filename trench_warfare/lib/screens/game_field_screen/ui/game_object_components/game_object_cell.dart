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

  @override
  void _addChildObjects() {
    _addTerrainModifierSprites();
    _addProductionCenterSprites();
    _addUnitsSprites();
    _addNationBannerSprites();

    if (_isHuman) {
      _addPathSprites();
    }

    _addBorder();
  }

  void _addTerrainModifierSprites() {
    final terrainModifier = _cell.terrainModifier;

    if (terrainModifier == null) {
      return;
    }

    final name = SpriteAtlasNames.getTerrainModifier(terrainModifier.type);

    _addSprite(name);
  }

  void _addProductionCenterSprites() {
    final productionCenter = _cell.productionCenter;

    if (productionCenter == null) {
      return;
    }

    final bodyName = SpriteAtlasNames.getProductionCenter(productionCenter);

    final levelName = SpriteAtlasNames.getProductionCenterLevel(productionCenter);

    _addSprite(bodyName);
    _addSprite(levelName);
    _addText(productionCenter.name);
  }

  void _addUnitsSprites() {
    if (_cell.units.isEmpty) {
      return;
    }

    _addUnitSprites(unit: _cell.activeUnit!, nation: _cell.nation, unitsTotal: _cell.units.length);
  }

  void _addNationBannerSprites() {
    if (_cell.isEmpty) {
      return;
    }

    _addSprite(SpriteAtlasNames.getNationBanner(_cell.nation!));
  }

  void _addPathSprites() {
    final pathItem = _cell.pathItem;

    if (pathItem == null) {
      return;
    }

    final pathSprite = SpriteAtlasNames.getPath(pathItem.type);

    _addSprite(pathSprite, decorator: pathItem.isActive ? null : _getDisabledDecorator());
  }

  void _addText(String? text) {
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

    add(textComponent);
  }

  _addBorder() {
    if (!GameCellBorder.needToDrawBorders(_cell, _gameField)) {
      return;
    }

    // The low priority (-1000) moves this component to back
    final border = GameCellBorder(_cell, _gameField)..priority = -1000;
    add(border);
  }
}
