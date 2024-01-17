part of game_objects;

class TerrainModifier extends GameObject {
  final TerrainModifierType type;

  bool get isLand => type != TerrainModifierType.seaMine;

  TerrainModifier({
    required this.type,
  });
}
