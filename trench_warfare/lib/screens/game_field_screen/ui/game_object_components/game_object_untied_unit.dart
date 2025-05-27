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

final class GameObjectUntiedUnit extends GameObjectComponentBase {
  late final Unit _unit;
  late final Nation _nation;

  GameObjectUntiedUnit({
    required super.spritesAtlas,
    required super.position,
    required Unit unit,
    required Nation nation,
    required super.isHuman,
  }) {
    _unit = unit;
    _nation = nation;
  }

  @override
  Future<void> _addChildObjects() async {
    await _addUnitSprites(unit: _unit, nation: _nation, unitsTotal: null, alwaysEnabled: true);
  }
}
