import 'package:trench_warfare/database/database.dart';

class SettingsStorageFacade {
  static final _dao = Database.keyValueDao;

  static const String _musicKey = 'musicSettingsKey';
  static const String _soundsKey = 'soundsSettingsKey';
  static const String _myUnitsSpeedKey = 'myUnitsSpeedSettingsKey';
  static const String _enemyUnitsSpeedKey = 'enemyUnitsSpeedSettingsKey';

  static double? get music => _dao.readDouble(_musicKey);

  static double? get sounds => _dao.readDouble(_soundsKey);

  static double? get myUnitsSpeed => _dao.readDouble(_myUnitsSpeedKey);

  static double? get enemyUnitsSpeed => _dao.readDouble(_enemyUnitsSpeedKey);

  static void setMusic(double value) => _dao.putDouble(_musicKey, value);

  static void setSounds(double value) => _dao.putDouble(_soundsKey, value);

  static void setMyUnitsSpeed(double value) => _dao.putDouble(_myUnitsSpeedKey, value);

  static void setEnemyUnitsSpeed(double value) => _dao.putDouble(_enemyUnitsSpeedKey, value);
}