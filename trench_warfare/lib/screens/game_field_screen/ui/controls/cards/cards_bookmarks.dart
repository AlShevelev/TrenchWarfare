part of card_controls;

class CardsBookmarks extends StatefulWidget {
  final CardsTab _startTab;

  final void Function(CardsTab) _onSwitchTab;

  const CardsBookmarks({
    super.key,
    required CardsTab startTab,
    required void Function(CardsTab) onSwitchTab,
  })  : _startTab = startTab,
        _onSwitchTab = onSwitchTab;

  @override
  State<CardsBookmarks> createState() => _CardsBookmarksState();
}

class _CardsBookmarksState extends State<CardsBookmarks> {
  static const double _inactiveTabPadding = 20;

  static const double _bookmarkWidth = 50;
  static const double _bookmarkHeight = 83;

  static const double _bookmarkStartOffset = 40;
  static const double _bookmarksGap = 5;

  late CardsTab _activeTab = widget._startTab;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _getBookmark(
          index: 0,
          tab: CardsTab.units,
          folder: 'units',
        ),
        _getBookmark(
          index: 1,
          tab: CardsTab.productionCenters,
          folder: 'production_centers',
        ),
        _getBookmark(
          index: 2,
          tab: CardsTab.terrainModifiers,
          folder: 'terrain_modifiers',
        ),
        _getBookmark(
          index: 3,
          tab: CardsTab.unitBoosters,
          folder: 'troop_boosters',
        ),
        _getBookmark(
          index: 4,
          tab: CardsTab.specialStrikes,
          folder: 'special_strikes',
        ),
      ],
    );
  }

  Widget _getBookmark({
    required int index,
    required CardsTab tab,
    required String folder,
  }) =>
      GestureDetector(
        onTap: () {
          setState(() {
            _activeTab = tab;
            widget._onSwitchTab(tab);
          });
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            index == 0 ? _bookmarkStartOffset : _bookmarksGap,
            _activeTab == tab ? 0 : _inactiveTabPadding,
            0,
            0,
          ),
          child: Container(
            width: _bookmarkWidth,
            height: _bookmarkHeight,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/images/screens/game_field/cards/$folder/bookmark.webp'),
              fit: BoxFit.cover,
            )),
          ),
        ),
      );
}
