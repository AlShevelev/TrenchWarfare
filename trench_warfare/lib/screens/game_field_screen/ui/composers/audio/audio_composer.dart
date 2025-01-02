import 'package:trench_warfare/audio/audio_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/update_game_event.dart';

class AudioComposer {
  AudioControllerPlaySound? _audioController;

  void setAudioController(AudioControllerPlaySound? audioController) => _audioController = audioController;

  void onUpdateGameEvent(UpdateGameEvent event) {
    switch (event) {
      case PlaySound(type: var type):
        _playSound(type);

      default:
        {}
    }
  }

  void _playSound(SoundType type) {
    _audioController?.playSound(type);
  }
}
