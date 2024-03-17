part of game_field_army_info;

abstract interface class GameFieldArmyInfoUnitsCache {
  Picture? getUnitPicture(String key);

  void putUnitPicture(String key, Picture picture);
}