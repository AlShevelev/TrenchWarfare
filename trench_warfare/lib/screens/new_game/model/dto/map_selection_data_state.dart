part of map_selection_dto_library;

sealed class MapSelectionState {}

class Loading extends MapSelectionState {}

class DataIsReady extends MapSelectionState {
  final List<MapTabDto> _tabs;
  Iterable<MapTabDto> get tabs => _tabs;

  MapTabDto get selectedTab => tabs.firstWhere((e) => e.selected);

  DataIsReady({required List<MapTabDto> tabs}): _tabs = tabs;

  DataIsReady copy(Iterable<MapTabDto> tabs) => DataIsReady(tabs: tabs.toList(growable: false));
}
