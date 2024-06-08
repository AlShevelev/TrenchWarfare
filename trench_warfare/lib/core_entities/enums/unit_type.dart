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
  carrier,
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
