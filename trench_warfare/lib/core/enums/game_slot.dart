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

  static void createFromIndex(int index) => GameSlot.values[index];
}