import 'package:objectbox/objectbox.dart';

@Entity()
class SaveSlotDbEntity {
  @Id()
  int dbId;

  /// [0-9]
  int slotNumber;

  /// Full name of the map (for example: assets/tiles/real/europe/the_battle_of_tannenburg.tmx)
  String mapFileName;

  bool isAutosave;

  int rows;

  int cols;

  @Property(type: PropertyType.date)
  DateTime saveDateTime;

  SaveSlotDbEntity({
    this.dbId = 0,
    required this.slotNumber,
    required this.mapFileName,
    required this.isAutosave,
    required this.rows,
    required this.cols,
    required this.saveDateTime,
  });
}
