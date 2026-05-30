import 'package:trench_warfare/shared/data/settings/settings_storage_read.dart';

class SettingsStorageReadStubImpl implements SettingsStorageRead {
  @override
  double get aiUnitsSpeed => 0;

  @override
  double get humanUnitsSpeed => 0;

  @override
  double get music => 0;

  @override
  bool get showBorders => false;

  @override
  bool get showDebugInfo => false;

  @override
  double get sounds => 0;
}