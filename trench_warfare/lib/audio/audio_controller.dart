part of audio;

abstract interface class AudioControllerPlaySound {
  void playSound(SoundType type);
}

abstract interface class AudioControllerSetVolume {
  /// the [value] is from [SettingsConstants.minValue] to [SettingsConstants.maxValue]
  void setSoundsVolume(double value);

  /// the [value] is from [SettingsConstants.minValue] to [SettingsConstants.maxValue]
  void setMusicVolume(double value);
}

class AudioController implements AudioControllerPlaySound, AudioControllerSetVolume {
  late final MusicPlayer _musicPlayer = MusicPlayer();

  late final SoundsPlayer _soundsPlayer = SoundsPlayer();

  ValueNotifier<AppLifecycleState>? _lifecycleNotifier;

  Future<void> init() async {
    await _soundsPlayer.init();
    _musicPlayer.init();
  }

  void dispose() {
    _lifecycleNotifier?.removeListener(_handleAppLifecycle);

    _stopAllSound();

    _musicPlayer.dispose();
    _soundsPlayer.dispose();
  }

  void attachLifecycleNotifier(ValueNotifier<AppLifecycleState> lifecycleNotifier) {
    _lifecycleNotifier?.removeListener(_handleAppLifecycle);

    lifecycleNotifier.addListener(_handleAppLifecycle);
    _lifecycleNotifier = lifecycleNotifier;
  }

  @override
  void playSound(SoundType type) => _soundsPlayer.play(type);

  @override
  void setMusicVolume(double value) => _musicPlayer.setVolume(value);

  @override
  void setSoundsVolume(double value) => _soundsPlayer.setVolume(value);

  void _handleAppLifecycle() {
    switch (_lifecycleNotifier!.value) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        _stopAllSound();
        break;
      case AppLifecycleState.resumed:
        _musicPlayer.resumeMusic();
        break;
      case AppLifecycleState.inactive:
        // No need to react to this state change.
        break;
      case AppLifecycleState.hidden:
        // No need to react to this state change.
        break;
    }
  }

  void _stopAllSound() {
    _musicPlayer.stopPlaying();
    _soundsPlayer.stopPlaying();
  }
}
