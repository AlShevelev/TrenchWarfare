part of audio;

class _SoundsQueueItem {
  final SoundType type;
  final int? duration;

  _SoundsQueueItem({required this.type, required this.duration});

  @override
  String toString() {
    return '_SoundsQueueItem(type: $type; duration: $duration)';
  }
}

class SoundsPlayer {
  late final AudioPlayer _player = AudioPlayer(playerId: 'SOUND_PLAYER');

  final _cachedSounds = <SoundType, Uri>{};

  // The played item is the first one
  final _soundsQueue = Queue<_SoundsQueueItem>();

  bool get _isMuted => _player.volume == 0.0;

  bool get _notReadyToPlay => _player.state == PlayerState.paused || _player.state == PlayerState.disposed;

  SoundsPlayer() {
    _player.onPlayerComplete.listen((_) => _switchToNextSound());

    _player.onPositionChanged.listen(
      (position) => _onPositionChanged(
        position: position,
        durationToInterrupt: _soundsQueue.firstOrNull?.duration,
      ),
    );
  }

  Future<void> init() async {
    for (final soundType in SoundType.values) {
      _cachedSounds[soundType] = await AudioCache.instance.load(_getSoundFile(soundType));
    }

    setVolume(SettingsStorageFacade.sounds);
    await _player.setPlaybackRate(1.0);
  }

  void dispose() {
    _player.dispose();
  }

  /// the [value] is from [SettingsConstants.minValue] to [SettingsConstants.maxValue]
  void setVolume(double value) => _player.setVolume(value / SettingsConstants.maxValue);

  Future<void> play({
    required SoundType type,
    int? duration,
    required SoundStrategy strategy,
    required bool ignoreIfPlayed,
  }) async {
    if (_isMuted || _notReadyToPlay) {
      return;
    }

    // The same track is in the queue - do nothing
    if (ignoreIfPlayed && _soundsQueue.any((t) => t.type == type)) {
      return;
    }

    switch (strategy) {
      case SoundStrategy.interrupt:
        {
          if (_player.state == PlayerState.playing) {
            await _player.stop();
          }

          _soundsQueue.clear();
          _soundsQueue.addLast(_SoundsQueueItem(type: type, duration: duration));
          await _playNextSound();
        }
      case SoundStrategy.putToQueue:
        {
          if (_player.state == PlayerState.playing) {
            _soundsQueue.addLast(_SoundsQueueItem(type: type, duration: duration));
          } else {
            _soundsQueue.clear();
            _soundsQueue.addLast(_SoundsQueueItem(type: type, duration: duration));
            await _playNextSound();
          }
        }
    }
  }

  void stopPlaying() {
    _player.stop();
    _soundsQueue.clear();
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

  Future<void> _playNextSound() async {
    final itemToPlay = _soundsQueue.firstOrNull;

    if (itemToPlay == null) {
      return;
    }

    await _player.play(UrlSource(_cachedSounds[itemToPlay.type].toString()));
  }

  Future<void> _switchToNextSound() async {
    await _player.stop();

    if (_soundsQueue.isNotEmpty) {
      _soundsQueue.removeFirst();
    }
    await _playNextSound();
  }

  /// [durationToInterrupt] in ms
  void _onPositionChanged({required Duration position, required int? durationToInterrupt}) {
    final positionMs = position.inMilliseconds;

    if (durationToInterrupt == null || durationToInterrupt == 0 || positionMs == 0) {
      return;
    }

    if (positionMs >= durationToInterrupt) {
      _switchToNextSound();
    }
  }
}
