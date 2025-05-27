/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of card_controls;

class _CardsBookmarks extends StatelessWidget {
  final Iterable<_TabDto> _tabs;

  final _CardsSelectionUserActions _userActions;

  static const double _inactiveTabPadding = 20;

  static const double _bookmarkWidth = 50;
  static const double _bookmarkHeight = 83;

  static const double _bookmarkStartOffset = 40;
  static const double _bookmarksGap = 5;

  const _CardsBookmarks({
    super.key,
    required Iterable<_TabDto> tabs,
    required _CardsSelectionUserActions userActions,
  })  : _tabs = tabs,
        _userActions = userActions;

  @override
  Widget build(BuildContext context) {
    final audioController = context.read<AudioController>();

    return Row(
        children: _tabs
            .mapIndexed(
              (index, tab) => _getBookmark(
                index: index,
                tabCode: tab.code,
                selected: tab.selected,
                folder: _getFolder(tab.code),
                audioController: audioController,
              ),
            )
            .toList(growable: false));
  }

  Widget _getBookmark({
    required int index,
    required _TabCode tabCode,
    required bool selected,
    required String folder,
    required AudioController audioController,
  }) =>
      GestureDetector(
        onTap: () {
          if (!selected) {
            audioController.playSound(SoundType.buttonClick);
            _userActions.onTabSelected(tabCode);
          }
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            index == 0 ? _bookmarkStartOffset : _bookmarksGap,
            selected ? 0 : _inactiveTabPadding,
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

  String _getFolder(_TabCode tabCode) => switch (tabCode) {
        _TabCode.units => 'units',
        _TabCode.productionCenters => 'production_centers',
        _TabCode.unitBoosters => 'troop_boosters',
        _TabCode.terrainModifiers => 'terrain_modifiers',
        _TabCode.specialStrikes => 'special_strikes',
      };
}
