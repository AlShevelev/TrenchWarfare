part of settings;

class _SettingsViewModel extends ViewModelBase implements _SettingsUserActions {
  final SingleStream<_SettingsScreenState> _uiState = SingleStream<_SettingsScreenState>();
  Stream<_SettingsScreenState> get uiState => _uiState.output;

  _DataIsLoaded? _state;

  @override
  SettingsResult get settingsValue => SettingsResult(
        music: _state?.music ?? SettingsConstants.defaultValue,
        sounds: _state?.sounds ?? SettingsConstants.defaultValue,
        myUnitsSpeed: _state?.myUnitsSpeed ?? SettingsConstants.defaultValue,
        enemyUnitsSpeed: _state?.enemyUnitsSpeed ?? SettingsConstants.defaultValue,
      );

  _SettingsViewModel() {
    _uiState.update(_Loading());
  }

  Future<void> init() async {
    // Fake data
    final dataState = _DataIsLoaded(
      music: SettingsConstants.defaultValue,
      sounds: SettingsConstants.defaultValue,
      myUnitsSpeed: SettingsConstants.defaultValue,
      enemyUnitsSpeed: SettingsConstants.defaultValue,
      minValue: SettingsConstants.minValue,
      maxValue: SettingsConstants.maxValue,
    );

    _state = dataState;

    _uiState.update(dataState.copy());
  }

  @override
  void onEnemyUnitsSpeedUpdated(double value) => _state = _state?.copy(enemyUnitsSpeed: value);

  @override
  void onMusicUpdated(double value) => _state = _state?.copy(music: value);

  @override
  void onMyUnitsSpeedUpdated(double value) => _state = _state?.copy(myUnitsSpeed: value);

  @override
  void onSoundsUpdated(double value) => _state = _state?.copy(sounds: value);

  @override
  void dispose() {
    _uiState.close();
  }
}
