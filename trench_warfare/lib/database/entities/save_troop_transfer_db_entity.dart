import 'package:objectbox/objectbox.dart';

@Entity()
class SaveTroopTransferDbEntity {
  @Id()
  int dbId;

  /// A link to [SaveSlotDbEntity]
  int slotDbId;

  // A link to [SaveNationDbEntity]
  int nationDbId;

  // A link to [SaveGameFieldCellDbEntity.cellId]
  int targetCellId;

  String troopTransferId;

  /// Is mapped to [_TroopTransferState.stateAlias]
  String stateAlias;

  /// A link to [SaveUnitDbEntity.unitId]
  String? selectedCarrierId;

  // A link to [SaveGameFieldCellDbEntity.cellId]
  int? landingPointCarrierCellId;

  // A link to [SaveGameFieldCellDbEntity.cellId]
  int? landingPointUnitsCellId;

  // A link to [SaveGameFieldCellDbEntity.cellId]
  int? gatheringPointCarrierCellId;

  // A link to [SaveGameFieldCellDbEntity.cellId]
  int? gatheringPointUnitsCellId;

  SaveTroopTransferDbEntity({
    this.dbId = 0,
    required this.slotDbId,
    required this.nationDbId,
    required this.targetCellId,
    required this.troopTransferId,
    required this.stateAlias,
    this.selectedCarrierId,
    this.landingPointCarrierCellId,
    this.landingPointUnitsCellId,
    this.gatheringPointCarrierCellId,
    this.gatheringPointUnitsCellId,
  });
}
