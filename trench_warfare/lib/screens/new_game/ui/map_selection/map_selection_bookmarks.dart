part of map_selection_ui;

class MapSelectionBookmarks extends StatefulWidget {
  final MapSelectionState _state;

  final void Function(TabCode) _onSwitchTab;

  const MapSelectionBookmarks({
    super.key,
    required MapSelectionState state,
    required void Function(TabCode) onSwitchTab,
  })  : _state = state,
        _onSwitchTab = onSwitchTab;

  @override
  State<MapSelectionBookmarks> createState() => _MapSelectionBookmarksState();
}

class _MapSelectionBookmarksState extends State<MapSelectionBookmarks> {
  static const double _inactiveTabPadding = 20;

  static const double _bookmarkHeight = 83;

  static const double _bookmarkStartOffset = 40;
  static const double _bookmarksGap = 10;

  bool get isLoading => widget._state is Loading;

  late TabCode _activeTab = isLoading
      ? TabCode.europe
      : (widget._state as DataIsReady).tabs.entries.firstWhere((e) => e.value.selected).key;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _getBookmark(
          leftPadding: _bookmarkStartOffset,
          tab: TabCode.europe,
        ),
        _getBookmark(
          leftPadding: _bookmarksGap,
          tab: TabCode.asia,
        ),
        _getBookmark(
          leftPadding: _bookmarksGap,
          tab: TabCode.newWorld,
        ),
      ],
    );
  }

  String _getTabImageName(TabCode tabCode) => switch (tabCode) {
        TabCode.europe => 'europe',
        TabCode.asia => 'asia',
        TabCode.newWorld => 'new_world',
      };

  String _getTabName(TabCode tabCode) => switch (tabCode) {
        TabCode.europe => tr('new_game_tab_europe'),
        TabCode.asia => tr('new_game_tab_asia'),
        TabCode.newWorld => tr('new_game_tab_new_world'),
      };

  Widget _getBookmark({
    required double leftPadding,
    required TabCode tab,
  }) {
    return GestureDetector(
      onTap: () {
        if (!isLoading) {
          setState(() {
            _activeTab = tab;
            widget._onSwitchTab(tab);
          });
        }
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(leftPadding, _activeTab == tab ? 0 : _inactiveTabPadding, 0, 0),
        child: Container(
          height: _bookmarkHeight,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/screens/new_game/bookmark_${_getTabImageName(tab)}.webp'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 20, 8, 0),
            child: StrokedText(
              text: _getTabName(tab),
              style: AppTypography.s20w600,
              textColor: AppColors.white,
              strokeColor: AppColors.halfDark,
              strokeWidth: 5,
            ),
          ),
        ),
      ),
    );
  }
}
