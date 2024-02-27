part of game_field_components;


final class GameObjectCell extends GameObjectComponentBase {
  late final GameFieldCell _cell;

  GameObjectCell(
    TextureAtlas spritesAtlas,
    GameFieldCell cell,
  ) : super(spritesAtlas: spritesAtlas, position: cell.center) {
    _cell = cell;
  }

  @override
  void _addSprites() {
    _addTerrainModifierSprites();
    _addProductionCenterSprites();
    _addUnitsSprites();
    //_addNationSprites();
    _addPathSprites();
  }

  void _addTerrainModifierSprites() {
    final terrainModifier = _cell.terrainModifier;

    if (terrainModifier == null) {
      return;
    }

    final name = switch (terrainModifier.type) {
      TerrainModifierType.antiAirGun => 'Terrain-modifiers-anti-air-gun',
      TerrainModifierType.barbedWire => 'Terrain-modifiers-wire',
      TerrainModifierType.landFort => 'Terrain-modifiers-land-fort',
      TerrainModifierType.landMine => 'Terrain-modifiers-land-mine',
      TerrainModifierType.seaMine => 'Terrain-modifiers-sea-mine',
      TerrainModifierType.trench => 'Terrain-modifiers-trench',
    };

    _addSprite(name);
  }

  void _addProductionCenterSprites() {
    final productionCenter = _cell.productionCenter;

    if (productionCenter == null) {
      return;
    }

    final levelDigit = switch (productionCenter.level) {
      ProductionCenterLevel.level1 => '1',
      ProductionCenterLevel.level2 => '2',
      ProductionCenterLevel.level3 => '3',
      ProductionCenterLevel.level4 => '4',
      ProductionCenterLevel.capital => '5',
    };

    final bodyName = switch (productionCenter.type) {
      ProductionCenterType.airField => 'Production-centers-air-field-level-$levelDigit',
      ProductionCenterType.navalBase => 'Production-centers-naval-base-level-$levelDigit',
      ProductionCenterType.factory => 'Production-centers-factory-level-$levelDigit',
      ProductionCenterType.city => 'Production-centers-city-level-$levelDigit',
    };

    final levelName = 'Production-centers-level-$levelDigit';

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

  void _addNationSprites() {
    final nation = _cell.nation;

    if (nation == null) {
      return;
    }

    final nationSuffix = switch (nation) {
      Nation.austriaHungary => 'Austro-Hungaria',
      Nation.belgium => 'Belgium',
      Nation.bulgaria => 'Bulgaria',
      Nation.china => 'China',
      Nation.france => 'France',
      Nation.germany => 'Germany',
      Nation.greatBritain => 'UK',
      Nation.greece => 'Greece',
      Nation.italy => 'Italy',
      Nation.japan => 'Japan',
      Nation.korea => 'Korea',
      Nation.mexico => 'Mexico',
      Nation.mongolia => 'Mongolia',
      Nation.montenegro => 'Montenegro',
      Nation.romania => 'Romania',
      Nation.russia => 'Russia',
      Nation.serbia => 'Serbia',
      Nation.turkey => 'Turkey',
      Nation.usa => 'US',
      Nation.usNorth => 'US-North',
      Nation.usSouth => 'US-South',
    };

    final name = _cell.terrainModifier != null || _cell.productionCenter != null || _cell.units.isNotEmpty ? 'Banner' : 'Flag';

    _addSprite('$name-$nationSuffix');
  }

  void _addPathSprites() {
    final pathItem = _cell.pathItem;

    if (pathItem == null) {
      return;
    }

    final pathSprite = switch (pathItem.type) {
      PathItemType.normal => 'Path-Normal',
      PathItemType.explosion => 'Path-Explosion',
      PathItemType.battle => 'Path-Battle',
      PathItemType.end => 'Path-End',
    };

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
      ..position = _position.translated(0, _baseSize.y * 0.2)
      ..priority = 2;

    add(textComponent);
  }
}
