import 'package:trench_warfare/shared/data/settings/settings_storage_facade.dart';
import 'package:trench_warfare/shared/data/settings/settings_storage_read.dart';

class SettingsStorageReadImpl implements SettingsStorageRead {
  @override
  double get aiUnitsSpeed => SettingsStorageFacade.aiUnitsSpeed;

  @override
  double get humanUnitsSpeed => SettingsStorageFacade.humanUnitsSpeed;

  @override
  double get music => SettingsStorageFacade.music;

  @override
  bool get showBorders => SettingsStorageFacade.showBorders;

  @override
  bool get showDebugInfo => SettingsStorageFacade.showDebugInfo;

  @override
  double get sounds => SettingsStorageFacade.sounds;
}