/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of game_field;

// DO NOT SWAP THE ELEMENTS - OTHERWISE THE SAVED GAMES MAY BE CORRUPTED
// A NEW ELEMENT MUST BE ADDED TO THE END OF THE LIST
enum PathItemType {
  normal,
  explosion,
  battle,
  battleNextUnreachableCell,
  end,
  loadUnit,
  unloadUnit;

  static PathItemType createFromIndex(int index) => PathItemType.values[index];
}