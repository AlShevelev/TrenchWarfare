part of card_controls;

sealed class _CardsScreenState {
  _TabDto get selectedTab;

  bool get isConfirmButtonEnabled;

  bool get isCloseActionEnabled;
}

class _DataIsReady extends _CardsScreenState {
  final List<_TabDto> _tabs;
  Iterable<_TabDto> get tabs => _tabs;

  @override
  _TabDto get selectedTab => tabs.firstWhere((e) => e.selected);

  @override
  bool get isConfirmButtonEnabled => selectedTab.cards.any((c) => c.selected);

  @override
  bool get isCloseActionEnabled => true;

  _DataIsReady({required List<_TabDto> tabs}): _tabs = tabs;

  _DataIsReady copy(Iterable<_TabDto> tabs) => _DataIsReady(tabs: tabs.toList(growable: false));
}