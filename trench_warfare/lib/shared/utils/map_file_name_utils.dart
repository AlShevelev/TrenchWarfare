/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

mixin MapFileNameUtils {
  String getPrefix(String mapFileName) => mapFileName.substring(0, _separatorIndex(mapFileName) + 1);

  String getFile(String mapFileName) =>
      mapFileName.substring(_separatorIndex(mapFileName) + 1, mapFileName.length);

  int _separatorIndex(String mapFileName) => mapFileName.lastIndexOf('/');
}
