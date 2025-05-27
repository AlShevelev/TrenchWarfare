/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of settings;

class _SettingsViewModel extends ViewModelBase implements _SettingsUserActions {
  final SingleStream<_SettingsScreenState> _uiState = SingleStream<_SettingsScreenState>();
  Stream<_SettingsScreenState> get uiState => _uiState.output;

  _DataIsLoaded? _state;

  AudioController? _audioController;

  @override
  SettingsResult get settingsValue => SettingsResult(
        music: _state?.music ?? SettingsConstants.defaultMusicValue,
        sounds: _state?.sounds ?? SettingsConstants.defaultSoundsValue,
        humanUnitsSpeed: _state?.myUnitsSpeed ?? SettingsConstants.defaultHumanUnitsSpeedValue,
        aiUnitsSpeed: _state?.enemyUnitsSpeed ?? SettingsConstants.defaultAiUnitsSpeedValue,
      );

  _SettingsViewModel() {
    _uiState.update(_Loading());
  }

  Future<void> init() async {
    final dataState = _DataIsLoaded(
      music: SettingsStorageFacade.music,
      sounds: SettingsStorageFacade.sounds,
      myUnitsSpeed: SettingsStorageFacade.humanUnitsSpeed,
      enemyUnitsSpeed: SettingsStorageFacade.aiUnitsSpeed,
      minValue: SettingsConstants.minValue,
      maxValue: SettingsConstants.maxValue,
    );

    _state = dataState;

    _uiState.update(dataState.copy());
  }

  void setAudioController(AudioController audioController) => _audioController = audioController;

  @override
  void onEnemyUnitsSpeedUpdated(double value) {
    _state = _state?.copy(enemyUnitsSpeed: value);
    SettingsStorageFacade.setAiUnitsSpeed(value);
  }

  @override
  void onMyUnitsSpeedUpdated(double value) {
    _state = _state?.copy(myUnitsSpeed: value);
    SettingsStorageFacade.setHumanUnitsSpeed(value);
  }

  @override
  void onMusicUpdated(double value) {
    _state = _state?.copy(music: value);
    SettingsStorageFacade.setMusic(value);

    _audioController?.setMusicVolume(value);
  }

  @override
  void onSoundsUpdated(double value) {
    _state = _state?.copy(sounds: value);
    SettingsStorageFacade.setSounds(value);

    _audioController?.setSoundsVolume(value);
    _audioController?.playSound(SoundType.buttonClick);
  }

  @override
  void dispose() {
    _uiState.close();
  }
}
