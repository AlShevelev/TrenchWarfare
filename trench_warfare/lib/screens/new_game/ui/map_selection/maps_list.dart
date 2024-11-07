part of map_selection_ui;

class MapsList extends StatelessWidget {
  final Iterable<MapCardDto>? _cards;

  final TabCode _selectedTab;

  final MapSelectionUserActions _userActions;

  const MapsList({
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
      return _getStateText(tr('new_game_list_loading'));
    }

    if (cards.isEmpty) {
      return _getStateText(tr('new_game_list_empty'));
    }

    return ListView.builder(
        key: PageStorageKey<String>(_selectedTab.name),
        itemCount: cards.length,
        itemBuilder: (context, index) {
          final card = cards.elementAt(index);

          return Card(
            selected: card.selected,
            tabCode: _selectedTab,
            card: card,
            userActions: _userActions,
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
