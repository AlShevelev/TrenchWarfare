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
  late final AudioPlayer _musicPlayer = AudioPlayer(playerId: 'MUSIC_PLAYER');
  late final AudioPlayer _soundsPlayer = AudioPlayer(playerId: 'SOUND_PLAYER');

  int _activeTrackIndex = 0;

  final _tracksToPlay = ['1_cover.ogg', '2.ogg', '3.ogg', '4.ogg', '5.ogg'];

  ValueNotifier<AppLifecycleState>? _lifecycleNotifier;

  final cachedSounds = <SoundType, Uri>{};

  AudioController() {
    _musicPlayer.onPlayerComplete.listen(_playNextMusicTrack);
  }

  Future<void> init() async {
    for (final soundType in SoundType.values) {
      cachedSounds[soundType] = await AudioCache.instance.load(_getSoundFile(soundType));
    }

    _setVolume(SettingsStorageFacade.sounds, _soundsPlayer);

    _setVolume(SettingsStorageFacade.music, _musicPlayer);
    _playMusicTrack(0);
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
  void playSound(SoundType type) {
    if (_isMuted(_soundsPlayer)) {
      return;
    }

    if (_readyToPlay(_soundsPlayer)) {
      _soundsPlayer.play(UrlSource(cachedSounds[type].toString()));
    }
  }

  @override
  void setMusicVolume(double value) {
    _setVolume(value, _musicPlayer);
  }

  @override
  void setSoundsVolume(double value) => _setVolume(value, _soundsPlayer);

  void _handleAppLifecycle() {
    switch (_lifecycleNotifier!.value) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        _stopAllSound();
        break;
      case AppLifecycleState.resumed:
        _resumeMusic();
        break;
      case AppLifecycleState.inactive:
        // No need to react to this state change.
        break;
      case AppLifecycleState.hidden:
        // No need to react to this state change.
        break;
    }
  }

  String _getSoundFile(SoundType type) {
    final fileName = switch (type) {
      SoundType.attackShot => 'attack/gun_shots',
      SoundType.attackExplosion => 'attack/explosion',
      SoundType.attackFlame => 'attack/flame',
      SoundType.attackGas => 'attack/gas_attack',
      SoundType.attackFlechettes => 'attack/flechettes',
      SoundType.attackPropagandaSuccess => 'attack/propaganda_success',
      SoundType.attackPropagandaFail => 'attack/propaganda_fail',
      SoundType.battleResultVictory => 'battle_result/victory',
      SoundType.battleResultDefeat => 'battle_result/defeat',
      SoundType.battleResultPcCaptured => 'battle_result/pc_captured',
      SoundType.battleResultPcDestroyed => 'battle_result/pc_destroyed',
      SoundType.battleResultManDeath => 'battle_result/man_death',
      SoundType.battleResultMechanicalDestroyed => 'battle_result/mechanical_destroyed',
      SoundType.battleResultShipDestroyed => 'battle_result/ship_destroyed',
      SoundType.productionCavalry => 'produce/cavalry',
      SoundType.productionInfantry => 'produce/infantry',
      SoundType.productionMechanical => 'produce/mechanical',
      SoundType.productionPC => 'produce/pc',
      SoundType.productionShip => 'produce/ship',
      SoundType.buttonClick => 'button_click',
      SoundType.dingUniversal => 'ding_universal_sound',
    };

    return 'audio/sounds/$fileName.ogg';
  }

  void _playNextMusicTrack(void _) {
    var newActiveTrackIndex = RandomGen.randomInt(_tracksToPlay.length);
    while (newActiveTrackIndex == _activeTrackIndex) {
      newActiveTrackIndex = RandomGen.randomInt(_tracksToPlay.length);
    }

    _playMusicTrack(newActiveTrackIndex);
  }

  Future<void> _playMusicTrack(int index) async {
    _activeTrackIndex = index;
    await _musicPlayer.play(AssetSource('audio/music/${_tracksToPlay[index]}'));
  }

  void _stopAllSound() {
    if (_musicPlayer.state == PlayerState.playing) {
      _musicPlayer.pause();
    }

    _soundsPlayer.stop();
  }

  Future<void> _resumeMusic() async {
    switch (_musicPlayer.state) {
      case PlayerState.paused:
        try {
          await _musicPlayer.resume();
        } catch (e) {
          _playMusicTrack(0);
        }
        break;
      case PlayerState.stopped:
        _playMusicTrack(0);
        break;
      case PlayerState.playing:
        break;
      case PlayerState.completed:
        _playMusicTrack(0);
        break;
      case PlayerState.disposed:
        break;
    }
  }

  /// the [value] is from [SettingsConstants.minValue] to [SettingsConstants.maxValue]
  void _setVolume(double value, AudioPlayer player) => player.setVolume(value / SettingsConstants.maxValue);

  bool _isMuted(AudioPlayer player) => player.volume == 0.0;

  bool _readyToPlay(AudioPlayer player) =>
      player.state == PlayerState.completed || player.state == PlayerState.stopped;
}
