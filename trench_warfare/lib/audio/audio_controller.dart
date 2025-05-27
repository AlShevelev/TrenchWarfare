/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of audio;

abstract interface class AudioControllerPlaySound {
  Future<void> playSound(
    SoundType type, {
    int? duration,
    SoundStrategy strategy = SoundStrategy.interrupt,
    bool ignoreIfPlayed = true,
  });
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
    await _musicPlayer.init();
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
  Future<void> playSound(
    SoundType type, {
    int? duration,
    SoundStrategy strategy = SoundStrategy.interrupt,
    bool ignoreIfPlayed = true,
  }) async =>
      await _soundsPlayer.play(
        type: type,
        duration: duration,
        strategy: strategy,
        ignoreIfPlayed: ignoreIfPlayed,
      );

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
