// DO NOT SWAP THE ELEMENTS - OTHERWISE THE SAVED GAMES MAY BE CORRUPTED
// A NEW ELEMENT MUST BE ADDED TO THE END OF THE LIST
enum CellTerrain {
  water,
  snow,
  sand,
  plain,
  wood,
  marsh,
  hills,
  mountains;

  static CellTerrain createFromIndex(int index) => CellTerrain.values[index];
}
