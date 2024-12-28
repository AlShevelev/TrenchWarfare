import 'package:trench_warfare/audio/audio_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/update_game_event.dart';

class AudioComposer {
  AudioControllerPlaySound? _audioController;

  void setAudioController(AudioControllerPlaySound? audioController) => _audioController = audioController;

  Future<void> onUpdateGameEvent(UpdateGameEvent event) async {
    switch (event) {
      case PlaySound(type: var type, delayAfterPlay: var delayAfterPlay):
        await _playSound(type, delayAfterPlay);

      default:
        {}
    }
  }

  Future<void> _playSound(SoundType type, int delayAfterPlay) async {
    _audioController?.playSound(type);
    await Future.delayed(Duration(milliseconds: delayAfterPlay));
  }
}
