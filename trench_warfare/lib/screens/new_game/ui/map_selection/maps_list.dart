part of map_selection_ui;

typedef _OnMapClick = void Function(int);

class MapsList extends StatefulWidget {
  final Iterable<MapCardDto>? _cards;

  final _OnMapClick _onMapSelected;

  final TabCode _selectedTab;

  MapsList({
    super.key,
    required MapSelectionState state,
    required _OnMapClick onMapSelected,
    required TabCode selectedTab,
  })  : _cards = state is Loading ? null : (state as DataIsReady).tabs[selectedTab]?.cards,
        _onMapSelected = onMapSelected,
        _selectedTab = selectedTab;

  @override
  State<StatefulWidget> createState() => _MapsListState();
}

class _MapsListState extends State<MapsList> {
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  late List<MapCardDto>? _cards;

  @override
  void initState() {
    _cards = widget._cards?.toList(growable: false);
    final cards = _cards;

    if (cards != null && cards.isNotEmpty) {
      _selectedIndex = cards.toList(growable: false).indexWhere((c) => c.selected);
      widget._onMapSelected(_selectedIndex);
    }
    super.initState();
  }

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
        itemCount: cards.length,
        itemBuilder: (context, index) => Card(
              selected: cards[index].selected,
              tabCode: widget._selectedTab,
              card: cards[index],
              index: index,
              onClick: widget._onMapSelected,
            ));
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
