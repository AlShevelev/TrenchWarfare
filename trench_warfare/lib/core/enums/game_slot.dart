/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

// DO NOT SWAP THE ELEMENTS - OTHERWISE THE SAVED GAMES MAY BE CORRUPTED
// A NEW ELEMENT MUST BE ADDED TO THE END OF THE LIST
enum GameSlot {
  slot0,
  slot1,
  slot2,
  slot3,
  slot4,
  slot5,
  slot6,
  slot7,
  slot8,
  slot9;

  static GameSlot createFromIndex(int index) => GameSlot.values[index];

  static GameSlot get autoSave => GameSlot.slot0;
}