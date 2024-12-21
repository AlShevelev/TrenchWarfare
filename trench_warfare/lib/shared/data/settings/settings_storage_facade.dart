import 'package:trench_warfare/database/database.dart';

class SettingsStorageFacade {
  static final _dao = Database.keyValueDao;

  static const String _musicKey = 'musicSettingsKey';
  static const String _soundsKey = 'soundsSettingsKey';
  static const String _humanUnitsSpeedKey = 'humanUnitsSpeedSettingsKey';
  static const String _aiUnitsSpeedKey = 'aiUnitsSpeedSettingsKey';

  static double? get music => _dao.readDouble(_musicKey);

  static double? get sounds => _dao.readDouble(_soundsKey);

  static double? get humanUnitsSpeed => _dao.readDouble(_humanUnitsSpeedKey);

  static double? get aiUnitsSpeed => _dao.readDouble(_aiUnitsSpeedKey);

  static void setMusic(double value) => _dao.putDouble(_musicKey, value);

  static void setSounds(double value) => _dao.putDouble(_soundsKey, value);

  static void setHumanUnitsSpeed(double value) => _dao.putDouble(_humanUnitsSpeedKey, value);

  static void setAiUnitsSpeed(double value) => _dao.putDouble(_aiUnitsSpeedKey, value);
}