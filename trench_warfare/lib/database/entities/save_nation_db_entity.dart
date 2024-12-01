import 'package:objectbox/objectbox.dart';

@Entity()
class SaveNationDbEntity {
  @Id()
  int dbId;

  /// A link to [SaveSlotDbEntity]
  int slotDbId;

  bool isHuman;

  /// An order of the nation in the player list (from zero)
  int playingOrder;

  /// An item's index in [Nation] enum
  int nation;

  bool defeated;

  bool isSideOfConflict;

  SaveNationDbEntity({
    this.dbId = 0,
    required this.slotDbId,
    required this.isHuman,
    required this.playingOrder,
    required this.nation,
    required this.defeated,
    required this.isSideOfConflict,
  });
}
