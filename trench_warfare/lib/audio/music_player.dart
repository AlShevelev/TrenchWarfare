part of audio;

class MusicPlayer {
  late final AudioPlayer _player = AudioPlayer(playerId: 'MUSIC_PLAYER');

  int _activeTrackIndex = 0;

  final _tracksToPlay = ['1_cover.ogg', '2.ogg', '3.ogg', '4.ogg', '5.ogg'];

  MusicPlayer() {
    _player.onPlayerComplete.listen(_playNextMusicTrack);
  }

  void init() {
    setVolume(SettingsStorageFacade.music);
    _playMusicTrack(0);
  }

  void dispose() {
    _player.dispose();
  }

  /// the [value] is from [SettingsConstants.minValue] to [SettingsConstants.maxValue]
  void setVolume(double value) => _player.setVolume(value / SettingsConstants.maxValue);

  void _playNextMusicTrack(void _) {
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