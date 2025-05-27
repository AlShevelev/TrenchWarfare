/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

import 'package:trench_warfare/audio/audio_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/update_game_event.dart';

class AudioComposer {
  AudioControllerPlaySound? _audioController;

  void setAudioController(AudioControllerPlaySound? audioController) => _audioController = audioController;

  Future<void> onUpdateGameEvent(UpdateGameEvent event) async {
    switch (event) {
      case PlaySound(
          type: var type,
          duration: var duration,
          strategy: var strategy,
          ignoreIfPlayed: var ignoreIfPlayed,
        ):
        await _audioController?.playSound(
          type,
          duration: duration,
          strategy: strategy,
          ignoreIfPlayed: ignoreIfPlayed,
        );

      default:
        {}
    }
  }
}
