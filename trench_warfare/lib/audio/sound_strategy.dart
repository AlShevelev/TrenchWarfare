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

enum SoundStrategy {
  /// Put the new sound to the queue
  putToQueue,

  /// Stop the playing sound, clear the queue and play the new one
  interrupt,
}