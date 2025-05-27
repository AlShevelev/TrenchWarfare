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

class MusicPlayer {
  late final AudioPlayer _player = AudioPlayer(playerId: 'MUSIC_PLAYER');

  int _activeTrackIndex = 0;

  final _tracksToPlay = ['1_cover.ogg', '2.ogg', '3.ogg', '4.ogg', '5.ogg'];

  static const _musicReduceVolumeFactor = 0.25;

  MusicPlayer() {
    _player.onPlayerComplete.listen((_) => _playNextMusicTrack());
  }

  Future<void> init() async {
    setVolume(SettingsStorageFacade.music);
    await _player.setPlaybackRate(1.0);
    await _playMusicTrack(0);
  }

  void dispose() {
    _player.dispose();
  }

  /// the [value] is from [SettingsConstants.minValue] to [SettingsConstants.maxValue]
  void setVolume(double value) =>
      _player.setVolume(_musicReduceVolumeFactor * value / SettingsConstants.maxValue);

  void _playNextMusicTrack() {
    var newActiveTrackIndex = RandomGen.randomInt(_tracksToPlay.length);
    while (newActiveTrackIndex == _activeTrackIndex) {
      newActiveTrackIndex = RandomGen.randomInt(_tracksToPlay.length);
    }

    _playMusicTrack(newActiveTrackIndex);
  }

  Future<void> _playMusicTrack(int index) async {
    _activeTrackIndex = index;
    await _player.play(AssetSource('audio/music/${_tracksToPlay[index]}'));
  }

  void stopPlaying() {
    if (_player.state == PlayerState.playing) {
      _player.pause();
    }
  }

  Future<void> resumeMusic() async {
    switch (_player.state) {
      case PlayerState.paused:
        try {
          await _player.resume();
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
}
