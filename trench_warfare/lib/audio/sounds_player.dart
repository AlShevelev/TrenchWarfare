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

class SoundsPlayer {
  late final List<AudioPlayer> _players = [
    AudioPlayer(playerId: 'SOUND_PLAYER_1'),
    AudioPlayer(playerId: 'SOUND_PLAYER_2'),
    AudioPlayer(playerId: 'SOUND_PLAYER_3'),
    AudioPlayer(playerId: 'SOUND_PLAYER_4'),
    AudioPlayer(playerId: 'SOUND_PLAYER_5'),
  ];

  final _cachedSounds = <SoundType, Uri>{};

  var _nextPlayerIndex = 0;

  bool get _isMuted => _players[0].volume == 0.0;

  static const _musicReduceVolumeFactor = 0.5;

  SoundsPlayer();

  Future<void> init() async {
    for (final soundType in SoundType.values) {
      _cachedSounds[soundType] = await AudioCache.instance.load(_getSoundFile(soundType));
    }

    setVolume(SettingsStorageFacade.sounds);

    for (var player in _players) {
      await player.setPlaybackRate(1.0);
    }
  }

  void dispose() {
    for (var player in _players) {
      player.dispose();
    }
    _nextPlayerIndex = 0;
  }

  /// the [value] is from [SettingsConstants.minValue] to [SettingsConstants.maxValue]
  void setVolume(double value) {
    for (var player in _players) {
      player.setVolume(
        _musicReduceVolumeFactor * value / SettingsConstants.maxValue,
      );
    }
  }

  Future<void> play({required SoundType type}) async {
    if (_isMuted) {
      return;
    }

    final player = _players[_nextPlayerIndex];

    _nextPlayerIndex++;
    if (_nextPlayerIndex == _players.length) {
      _nextPlayerIndex = 0;
    }

    await player.play(UrlSource(_cachedSounds[type].toString()));
  }

  void stopPlaying() {
    for (var player in _players) {
      player.stop();
    }
    _nextPlayerIndex = 0;
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
}
