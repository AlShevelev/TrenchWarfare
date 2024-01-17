part of game_objects;

class ProductionCenter extends GameObject {
  final ProductionCenterType type;
  final ProductionCenterLevel level;
  final String name;

  bool get isLand => type != ProductionCenterType.navalBase;

  ProductionCenter({
    required this.type,
    required this.level,
    required this.name,
  });
}
