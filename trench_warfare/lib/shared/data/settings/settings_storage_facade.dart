/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

import 'package:trench_warfare/core/settings_constants.dart';
import 'package:trench_warfare/database/database.dart';

class SettingsStorageFacade {
  static final _dao = Database.keyValueDao;

  static const String _musicKey = 'musicSettingsKey';
  static const String _soundsKey = 'soundsSettingsKey';
  static const String _humanUnitsSpeedKey = 'humanUnitsSpeedSettingsKey';
  static const String _aiUnitsSpeedKey = 'aiUnitsSpeedSettingsKey';
  static const String _showBorderKey = 'showBorderKey';

  static double _music = _dao.readDouble(_musicKey) ?? SettingsConstants.defaultMusicValue;
  static double _sounds = _dao.readDouble(_soundsKey) ?? SettingsConstants.defaultSoundsValue;
  static double _humanUnitsSpeed =
      _dao.readDouble(_humanUnitsSpeedKey) ?? SettingsConstants.defaultHumanUnitsSpeedValue;
  static double _aiUnitsSpeed =
      _dao.readDouble(_aiUnitsSpeedKey) ?? SettingsConstants.defaultAiUnitsSpeedValue;
  static bool _showBorders = _dao.readBool(_showBorderKey) ?? true;

  static double get music => _music;

  static double get sounds => _sounds;

  static double get humanUnitsSpeed => _humanUnitsSpeed;

  static double get aiUnitsSpeed => _aiUnitsSpeed;

  static bool get showBorders => _showBorders;

  static void setMusic(double value) {
    _dao.putDouble(_musicKey, value);
    _music = value;
  }

  static void setSounds(double value) {
    _dao.putDouble(_soundsKey, value);
    _sounds = value;
  }

  static void setHumanUnitsSpeed(double value) {
    _dao.putDouble(_humanUnitsSpeedKey, value);
    _humanUnitsSpeed = value;
  }

  static void setAiUnitsSpeed(double value) {
    _dao.putDouble(_aiUnitsSpeedKey, value);
    _aiUnitsSpeed = value;
  }

  static void setShowBorders(bool value) {
    _dao.putBool(_showBorderKey, value);
    _showBorders = value;
  }
}
