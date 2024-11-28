import 'package:objectbox/objectbox.dart';

@Entity()
class SaveSettingsStorageDbEntity {
  @Id()
  int dbId;

  /// A link to [SaveSlotDbEntity]
  int slotDbId;

  double? zoom;

  double? cameraPositionX;

  double? cameraPositionY;

  SaveSettingsStorageDbEntity({
    this.dbId = 0,
    required this.slotDbId,
    this.zoom,
    this.cameraPositionX,
    this.cameraPositionY,
  });
}
