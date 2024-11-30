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
  unloadUnit,
}