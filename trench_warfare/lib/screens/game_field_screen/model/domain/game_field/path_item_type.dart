part of game_field;

enum PathItemType {
  normal,
  explosion,
  battle,
  battleNextUnreachableCell,
  end,
  loadUnit,
  unloadUnit,
}