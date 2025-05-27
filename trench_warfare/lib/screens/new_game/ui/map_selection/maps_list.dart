/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of map_selection_ui;

class _MapsList extends StatelessWidget {
  final Iterable<MapCardDto>? _cards;

  final TabCode _selectedTab;

  final MapSelectionUserActions _userActions;

  const _MapsList({
    super.key,
    required Iterable<MapCardDto>? cards,
    required TabCode selectedTab,
    required MapSelectionUserActions userActions,
  })  : _cards = cards,
        _selectedTab = selectedTab,
        _userActions = userActions;

  @override
  Widget build(BuildContext context) {
    final cards = _cards;

    if (cards == null) {
      return _getStateText(tr('loading'));
    }

    if (cards.isEmpty) {
      return _getStateText(tr('new_game_list_empty'));
    }

    return ListView.builder(
        key: PageStorageKey<String>(_selectedTab.name),
        itemCount: cards.length,
        itemBuilder: (context, index) {
          final card = cards.elementAt(index);

          return _Card(
            selected: card.selected,
            tabCode: _selectedTab,
            card: card,
            userActions: _userActions,
            mapRows: card.mapRows,
            mapCols: card.mapCols,
          );
        });
  }

  Widget _getStateText(String text) {
    return Center(
      child: DefaultTextStyle(
        style: AppTypography.s20w600,
        child: Text(text),
      ),
    );
  }
}
