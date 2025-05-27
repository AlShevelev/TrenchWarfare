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
