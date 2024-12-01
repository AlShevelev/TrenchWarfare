// DO NOT SWAP THE ELEMENTS - OTHERWISE THE SAVED GAMES MAY BE CORRUPTED
// A NEW ELEMENT MUST BE ADDED TO THE END OF THE LIST
enum ProductionCenterLevel {
  level1,
  level2,
  level3,
  level4,
  capital;

  bool operator >= (covariant ProductionCenterLevel other) =>
    getWeight() >= other.getWeight();

  bool operator < (covariant ProductionCenterLevel other) =>
      getWeight() < other.getWeight();

  int getWeight() =>
      switch(this) {
        ProductionCenterLevel.level1 => 1,
        ProductionCenterLevel.level2 => 2,
        ProductionCenterLevel.level3 => 3,
        ProductionCenterLevel.level4 => 4,
        ProductionCenterLevel.capital => 5,
      };
}