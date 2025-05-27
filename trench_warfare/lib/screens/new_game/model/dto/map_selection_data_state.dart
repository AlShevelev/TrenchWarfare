/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of map_selection_dto_library;

sealed class MapSelectionState {
  MapTabDto get selectedTab;

  bool get isConfirmButtonEnabled;

  bool get isCloseActionEnabled;
}

class Loading extends MapSelectionState {
  final MapTabDto _selectedTab = MapTabDto(selected: true, code: TabCode.europe, cards: []);
  @override
  MapTabDto get selectedTab => _selectedTab;

  @override
  bool get isConfirmButtonEnabled => false;

  @override
  bool get isCloseActionEnabled => false;
}

class DataIsReady extends MapSelectionState {
  final List<MapTabDto> _tabs;
  Iterable<MapTabDto> get tabs => _tabs;

  @override
  MapTabDto get selectedTab => tabs.firstWhere((e) => e.selected);

  @override
  bool get isConfirmButtonEnabled => selectedTab.cards.any((c) => c.selected);

  @override
  bool get isCloseActionEnabled => true;

  DataIsReady({required List<MapTabDto> tabs}): _tabs = tabs;

  DataIsReady copy(Iterable<MapTabDto> tabs) => DataIsReady(tabs: tabs.toList(growable: false));
}
