part of audio;

class SoundsPlayer {
  late final AudioPlayer _soundsPlayer = AudioPlayer(playerId: 'SOUND_PLAYER');

  final _cachedSounds = <SoundType, Uri>{};

  Future<void> init() async {
    for (final soundType in SoundType.values) {
      _cachedSounds[soundType] = await AudioCache.instance.load(_getSoundFile(soundType));
    }

    setVolume(SettingsStorageFacade.sounds);
  }

  void dispose() {
    _soundsPlayer.dispose();
  }

  /// the [value] is from [SettingsConstants.minValue] to [SettingsConstants.maxValue]
  void setVolume(double value) => _soundsPlayer.setVolume(value / SettingsConstants.maxValue);

  void play(SoundType type) {
    if (_isMuted(_soundsPlayer)) {
      return;
    }

    if (_readyToPlay(_soundsPlayer)) {
      _soundsPlayer.play(UrlSource(_cachedSounds[type].toString()));
    }
  }

  void stopPlaying() => _soundsPlayer.stop();

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

  bool _isMuted(AudioPlayer player) => player.volume == 0.0;

  bool _readyToPlay(AudioPlayer player) =>
      player.state == PlayerState.completed || player.state == PlayerState.stopped;
}