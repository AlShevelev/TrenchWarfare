// DO NOT SWAP THE ELEMENTS - OTHERWISE THE SAVED GAMES MAY BE CORRUPTED
// A NEW ELEMENT MUST BE ADDED TO THE END OF THE LIST
enum UnitType {
  armoredCar,
  artillery,
  infantry,
  cavalry,
  machineGunnersCart,
  machineGuns,
  tank,
  destroyer,
  cruiser,
  battleship,
  carrier;

  static UnitType createFromIndex(int index) => UnitType.values[index];
}

extension UnitTypeExt on UnitType {
  bool get isLand =>
      this == UnitType.armoredCar ||
      this == UnitType.artillery ||
      this == UnitType.infantry ||
      this == UnitType.cavalry ||
      this == UnitType.machineGunnersCart ||
      this == UnitType.machineGuns ||
      this == UnitType.tank;
}
