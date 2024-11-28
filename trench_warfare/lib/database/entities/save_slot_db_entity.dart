import 'package:objectbox/objectbox.dart';

@Entity()
class SaveSlotDbEntity {
  @Id()
  int dbId;

  /// [0-9]
  int slotNumber;

  /// For example real/europe/the_battle_of_tannenburg
  String mapId;

  bool isAutosave;

  int day;

  @Property(type: PropertyType.date)
  DateTime saveDateTime;

  SaveSlotDbEntity({
    this.dbId = 0,
    required this.slotNumber,
    required this.mapId,
    required this.isAutosave,
    required this.day,
    required this.saveDateTime,
  });
}
