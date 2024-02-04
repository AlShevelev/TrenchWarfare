part of game_field_components;

final class GameObjectUntiedUnit extends GameObjectComponentBase {
  late final Unit _unit;
  late final Nation _nation;

  GameObjectUntiedUnit({
    required super.spritesAtlas,
    required super.position,
    required Unit unit,
    required Nation nation,
  }) {
    _unit = unit;
    _nation = nation;
  }

  @override
  void _addSprites() {
    _addUnitSprites(unit: _unit, nation: _nation, unitsTotal: null, alwaysEnabled: true);
  }
}
