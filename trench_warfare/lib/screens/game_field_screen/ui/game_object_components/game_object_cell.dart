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

final class GameObjectCell extends GameObjectComponentBase {
  final GameFieldCellRead _cell;

  final GameFieldRead _gameField;

  final AppLocale _locale;

  GameObjectCell(
    TextureAtlas spritesAtlas,
    GameFieldCellRead cell,
    bool isHuman,
    GameFieldRead gameField,
    AppLocale locale,
  )   : _cell = cell,
        _gameField = gameField,
        _locale = locale,
        super(spritesAtlas: spritesAtlas, position: cell.center, isHuman: isHuman);

  static bool needToDrawCell(GameFieldCellRead cell, GameFieldRead gameField) {
    if (!cell.isEmpty || cell.pathItem != null) {
      return true;
    }

    return GameCellBorder.needToDrawBorders(cell, gameField);
  }

  @override
  Future<void> _addChildObjects() async {
    final root = SnapshotComponent();
    await add(root);

    await _addBorder(root: root);

    await _addTerrainModifierSprites(root: root);
    await _addProductionCenterSprites(root: root);
    await _addUnitsSprites(root: root);
    await _addNationBannerSprites(root: root);

    if (_isHuman) {
      await _addPathSprites(root: root);
    }
  }

  Future<void> _addTerrainModifierSprites({Component? root}) async {
    final terrainModifier = _cell.terrainModifier;

    if (terrainModifier == null) {
      return;
    }

    final name = SpriteAtlasNames.getTerrainModifier(terrainModifier.type);

    await _addSprite(name, root: root);
  }

  Future<void> _addProductionCenterSprites({Component? root}) async {
    final productionCenter = _cell.productionCenter;

    if (productionCenter == null) {
      return;
    }

    final bodyName = SpriteAtlasNames.getProductionCenter(productionCenter);

    final levelName = SpriteAtlasNames.getProductionCenterLevel(productionCenter);

    await _addSprite(bodyName, root: root);
    await _addSprite(levelName, root: root);
    await _addText(productionCenter.name[_locale], root: root);
  }

  Future<void> _addUnitsSprites({Component? root}) async {
    if (_cell.units.isEmpty) {
      return;
    }

    await _addUnitSprites(
      unit: _cell.activeUnit!,
      nation: _cell.nation,
      unitsTotal: _cell.units.length,
      root: root,
    );
  }

  Future<void> _addNationBannerSprites({Component? root}) async {
    if (_cell.isEmpty) {
      return;
    }

    await _addSprite(SpriteAtlasNames.getNationBanner(_cell.nation!), root: root);
  }

  Future<void> _addPathSprites({Component? root}) async {
    final pathItem = _cell.pathItem;

    if (pathItem == null) {
      return;
    }

    final pathSprite = SpriteAtlasNames.getPath(pathItem.type);

    await _addSprite(
      pathSprite,
      decorator: pathItem.isActive ? null : _getDisabledDecorator(),
      root: root,
    );
  }

  Future<void> _addText(String? text, {Component? root}) async {
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

    await (root ?? this).add(textComponent);
  }

  Future<void> _addBorder({Component? root}) async {
    if (!GameCellBorder.needToDrawBorders(_cell, _gameField)) {
      return;
    }

    // The low priority (-1000) moves this component to back
    final border = GameCellBorder(_cell, _gameField)..priority = -1000;
    await (root ?? this).add(border);
  }
}
