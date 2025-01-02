part of audio;

enum SoundStrategy {
  /// Put the new sound to the queue
  putToQueue,

  /// Stop the playing sound, clear the queue and play the new one
  interrupt,
}