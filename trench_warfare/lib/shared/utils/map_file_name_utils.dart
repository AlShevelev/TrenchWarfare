mixin MapFileNameUtils {
  String getPrefix(String mapFileName) => mapFileName.substring(0, _separatorIndex(mapFileName) + 1);

  String getFile(String mapFileName) =>
      mapFileName.substring(_separatorIndex(mapFileName) + 1, mapFileName.length);

  int _separatorIndex(String mapFileName) => mapFileName.lastIndexOf('/');
}
