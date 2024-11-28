import 'package:objectbox/objectbox.dart';

@Entity()
class SaveTroopTransferDbEntity {
  @Id()
  int dbId;

  /// A link to [SaveSlotDbEntity]
  int slotDbId;

  // A link to [SaveNationDbEntity]
  int nationDbId;

  // A link to [SaveGameFieldCellDbEntity]
  int targetCellDbId;

  int troopTransferId;

  /// Is mapped to [_TroopTransferState]: "Init"; "Gathering"; "LoadingToCarrier"; "Transporting";
  /// "Landing"; "MoveUnitsAfterLanding"; "Completed"
  String stateName;

  /// A link to [SaveUnitDbEntity]
  int? selectedCarrierDbId;

  // A link to [SaveGameFieldCellDbEntity]
  int? landingPointCarrierCellDbId;

  // A link to [SaveGameFieldCellDbEntity]
  int? landingPointUnitsCellDbId;

  // A link to [SaveGameFieldCellDbEntity]
  int? gatheringPointCarrierCellDbId;

  // A link to [SaveGameFieldCellDbEntity]
  int? gatheringPointUnitsCellDbId;

  SaveTroopTransferDbEntity({
    this.dbId = 0,
    required this.slotDbId,
    required this.nationDbId,
    required this.targetCellDbId,
    required this.troopTransferId,
    required this.stateName,
    this.selectedCarrierDbId,
    this.landingPointCarrierCellDbId,
    this.landingPointUnitsCellDbId,
    this.gatheringPointCarrierCellDbId,
    this.gatheringPointUnitsCellDbId,
  });
}
