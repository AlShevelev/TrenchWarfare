part of game_field_army_info;

class GameFieldArmyInfoUnit extends StatelessWidget {
  final Unit _unit;

  final TextureAtlas _spritesAtlas;

  final Nation _nation;

  final GameFieldArmyInfoUnitsCache _cache;

  const GameFieldArmyInfoUnit({
    super.key,
    required Unit unit,
    required Nation nation,
    required TextureAtlas spritesAtlas,
    required GameFieldArmyInfoUnitsCache cache,
  })  : _unit = unit,
        _spritesAtlas = spritesAtlas,
        _nation = nation,
        _cache = cache;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      child: CustomPaint(
        painter: GameFieldArmyInfoUnitPainter(
          unit: _unit,
          nation: _nation,
          spritesAtlas: _spritesAtlas,
          cache: _cache,
        ),
        child: const SizedBox(
          width: 55,
          height: 50,
          child: null,
        ),
      ),
    );
  }
}
