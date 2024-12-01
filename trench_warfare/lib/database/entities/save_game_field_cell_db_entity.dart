import 'package:objectbox/objectbox.dart';

@Entity()
class SaveGameFieldCellDbEntity {
  @Id()
  int dbId;

  /// A link to [SaveSlotDbEntity]
  int slotDbId;

  int row;

  int col;

  int cellId;

  double centerX;

  double centerY;

  /// An item's index in [CellTerrain] enum
  int terrain;

  bool hasRiver;

  bool hasRoad;

  /// An item's index in [Nation] enum
  int? nation;

  /// An item's index in [ProductionCenterType] enum
  int? productionCenterType;

  /// An item's index in [ProductionCenterLevel] enum
  int? productionCenterLevel;

  /// An item's index in [TerrainModifierType] enum
  int? terrainModifier;

  /// An item's index in [PathItemType] enum
  int? pathItemType;

  bool? pathItemIsActive;

  double? pathItemMovementPointsLeft;

  SaveGameFieldCellDbEntity({
    this.dbId = 0,
    required this.slotDbId,
    required this.row,
    required this.col,
    required this.cellId,
    required this.centerX,
    required this.centerY,
    required this.terrain,
    required this.hasRiver,
    required this.hasRoad,
    this.nation,
    this.productionCenterType,
    this.productionCenterLevel,
    this.terrainModifier,
    this.pathItemType,
    this.pathItemIsActive,
    this.pathItemMovementPointsLeft,
  });
}
