part of game_field_army_info;

class GameFieldArmyInfoUnit extends StatelessWidget {
  late final Unit _unit;

  late final TextureAtlas _spritesAtlas;

  late final GameFieldArmyInfoUnitsCache _cache;

  GameFieldArmyInfoUnit({
    super.key,
    required Unit unit,
    required TextureAtlas spritesAtlas,
    required GameFieldArmyInfoUnitsCache cache,
  }) {
    _unit = unit;
    _spritesAtlas = spritesAtlas;
    _cache = cache;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: CustomPaint(
        painter: GameFieldArmyInfoUnitPainter(
          unit: _unit,
          nation: Nation.austriaHungary,
          spritesAtlas: _spritesAtlas,
          cache: _cache,
        ),
        child: const SizedBox(
          width: 50,
          height: 50,
          child: null,
        ),
      ),
    );
  }
}
