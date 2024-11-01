part of map_selection_dto_library;

sealed class MapSelectionState {}

class Loading extends MapSelectionState {}

class DataIsReady extends MapSelectionState {
  final Map<TabCode, Tab> tabs;

  DataIsReady({required this.tabs});

  DataIsReady copy(Map<TabCode, Tab> tabs) => DataIsReady(
        tabs: tabs,
      );
}
