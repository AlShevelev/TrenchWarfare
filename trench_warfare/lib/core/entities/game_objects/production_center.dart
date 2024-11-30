part of game_objects;

class ProductionCenter extends GameObject {
  final ProductionCenterType type;

  late ProductionCenterLevel _level;
  ProductionCenterLevel get level => _level;

  ProductionCenterLevel get maxLevel => ProductionCenter.getMaxLevel(type);

  ProductionCenterLevel? get nextLevel => ProductionCenter.getNextLevel(type, level);

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

  static ProductionCenterLevel getMaxLevel(ProductionCenterType type) => switch(type) {
    ProductionCenterType.airField => ProductionCenterLevel.level2,
    ProductionCenterType.navalBase => ProductionCenterLevel.level3,
    ProductionCenterType.factory => ProductionCenterLevel.level4,
    ProductionCenterType.city => ProductionCenterLevel.capital,
  };

  static ProductionCenterLevel? getNextLevel(ProductionCenterType type, ProductionCenterLevel? current) {
    if (getMaxLevel(type) == current) {
      return null;
    }

    return switch(current) {
      null => ProductionCenterLevel.level1,
      ProductionCenterLevel.level1 => ProductionCenterLevel.level2,
      ProductionCenterLevel.level2 => ProductionCenterLevel.level3,
      ProductionCenterLevel.level3 => ProductionCenterLevel.level4,
      ProductionCenterLevel.level4 => ProductionCenterLevel.capital,
      ProductionCenterLevel.capital => null,
    };
  }
}
