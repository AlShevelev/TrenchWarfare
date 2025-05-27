/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

import 'package:objectbox/objectbox.dart';

@Entity()
class SaveUnitDbEntity {
  @Id()
  int dbId;

  /// A link to [SaveSlotDbEntity]
  int slotDbId;

  /// Is not null if the unit in on a cell
  int? cellDbId;

  /// Is not null if the unit in on a cell
  int? carrierDbId;

  /// A link to [SaveTroopTransferDbEntity]
  /// If the unit is a part of a troops transporting
  int? troopTransferDbId;

  String unitId;

  /// Sorting order in a cell
  int orderInCell;

  /// An item's index in [UnitBoost] enum
  int? boost1;

  /// An item's index in [UnitBoost] enum
  int? boost2;

  /// An item's index in [UnitBoost] enum
  int? boost3;

  int tookPartInBattles;

  double fatigue;

  double health;

  double movementPoints;

  double defence;

  /// An item's index in [UnitType] enum
  int type;

  /// An item's index in [UnitState] enum
  int state;

  bool isInDefenceMode;

  SaveUnitDbEntity({
    this.dbId = 0,
    required this.slotDbId,
    this.cellDbId,
    this.troopTransferDbId,
    this.carrierDbId,
    required this.unitId,
    required this.orderInCell,
    this.boost1,
    this.boost2,
    this.boost3,
    required this.tookPartInBattles,
    required this.fatigue,
    required this.health,
    required this.movementPoints,
    required this.defence,
    required this.type,
    required this.state,
    required this.isInDefenceMode,
  });
}
