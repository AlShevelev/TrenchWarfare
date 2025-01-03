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
  }

  void dispose() {
    _player.dispose();
  }

  /// the [value] is from [SettingsConstants.minValue] to [SettingsConstants.maxValue]
  void setVolume(double value) => _player.setVolume(value / SettingsConstants.maxValue);

  void play({
    required SoundType type,
    int? duration,
    required SoundStrategy strategy,
    required bool ignoreIfPlayed,
  }) {
    Logger.error('[1.0] SoundsPlayer. play(type: $type, strategy: $strategy, _player.state: ${_player.state})', tag: 'SOUND_BUG');
    if (_isMuted || _notReadyToPlay) {
      Logger.error('[1.1] SoundsPlayer. return [type: $type]', tag: 'SOUND_BUG');
      return;
    }

    // The same track is in the queue - do nothing
    if (ignoreIfPlayed && _soundsQueue.any((t) => t.type == type)) {
      Logger.error('[1.2] SoundsPlayer. return [type: $type]', tag: 'SOUND_BUG');
      return;
    }

    switch (strategy) {
      case SoundStrategy.interrupt:
        {
          if (_player.state == PlayerState.playing) {
            _player.stop();
          }

          _soundsQueue.clear();
          _soundsQueue.addLast(_SoundsQueueItem(type: type, duration: duration));
          _playNextSound();
        }
      case SoundStrategy.putToQueue:
        {
          Logger.error('[1.4] SoundsPlayer. SoundStrategy.putToQueue. type: $type, _player.state is: ${_player.state}', tag: 'SOUND_BUG');
          if (_player.state == PlayerState.playing) {
            Logger.error('[2] SoundsPlayer. The sound is placed as last', tag: 'SOUND_BUG');
            _soundsQueue.addLast(_SoundsQueueItem(type: type, duration: duration));
          } else {
            _soundsQueue.clear();
            _soundsQueue.addLast(_SoundsQueueItem(type: type, duration: duration));
            _playNextSound();
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

  void _playNextSound() {
    Logger.error('[4] SoundsPlayer._playNextSound() is called', tag: 'SOUND_BUG');
    final itemToPlay = _soundsQueue.firstOrNull;

    Logger.error('[5] SoundsPlayer. item to play is: $itemToPlay', tag: 'SOUND_BUG');

    if (itemToPlay == null) {
      return;
    }

    Logger.error('[6] SoundsPlayer. start playing', tag: 'SOUND_BUG');
    _player.play(UrlSource(_cachedSounds[itemToPlay.type].toString()));
  }

  void _switchToNextSound() {
    Logger.error('[3] SoundsPlayer._switchToNextSound() is called', tag: 'SOUND_BUG');
    _player.stop();
    _soundsQueue.removeFirst();
    _playNextSound();
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
