part of game_objects;

class ProductionCenter extends GameObject {
  final ProductionCenterType type;

  late ProductionCenterLevel _level;
  ProductionCenterLevel get level => _level;

  final String name;

  bool get isLand => type != ProductionCenterType.navalBase;

  ProductionCenter({
    required this.type,
    required ProductionCenterLevel level,
    required this.name,
  }) {
    _level = level;
  }

  void setLevel(ProductionCenterLevel newLevel) => _level = newLevel;
}
