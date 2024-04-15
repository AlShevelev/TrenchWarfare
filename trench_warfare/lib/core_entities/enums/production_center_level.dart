enum ProductionCenterLevel {
  level1,
  level2,
  level3,
  level4,
  capital;

  bool operator >=(covariant ProductionCenterLevel other) =>
    _getWeight() >= other._getWeight();

  int _getWeight() =>
      switch(this) {
        ProductionCenterLevel.level1 => 1,
        ProductionCenterLevel.level2 => 2,
        ProductionCenterLevel.level3 => 3,
        ProductionCenterLevel.level4 => 4,
        ProductionCenterLevel.capital => 5,
      };
}