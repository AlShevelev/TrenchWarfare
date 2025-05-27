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

class _Bookmarks extends StatelessWidget {
  final MapSelectionUserActions _userActions;

  static const double _inactiveTabPadding = 20;

  static const double _bookmarkHeight = 83;

  static const double _bookmarkStartOffset = 40;
  static const double _bookmarksGap = 5;

  final bool _isLoading;

  final TabCode _activeTab;

  const _Bookmarks({
    super.key,
    required TabCode activeTab,
    required bool isLoading,
    required MapSelectionUserActions userActions,
  })  : _activeTab = activeTab,
        _isLoading = isLoading,
        _userActions = userActions;

  @override
  Widget build(BuildContext context) {
    final audioController = context.read<AudioController>();

    return Row(
      children: [
        _getBookmark(
          leftPadding: _bookmarkStartOffset,
          tab: TabCode.europe,
          audioController: audioController,
        ),
        _getBookmark(
          leftPadding: _bookmarksGap,
          tab: TabCode.asia,
          audioController: audioController,
        ),
        _getBookmark(
          leftPadding: _bookmarksGap,
          tab: TabCode.newWorld,
          audioController: audioController,
        ),
      ],
    );
  }

  Widget _getBookmark({
    required double leftPadding,
    required TabCode tab,
    required AudioController audioController,
  }) {
    return GestureDetector(
      onTap: () {
        if (!_isLoading && _activeTab != tab) {
          audioController.playSound(SoundType.buttonClick);
          _userActions.onTabSelected(tab);
        }
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(leftPadding, _activeTab == tab ? 0 : _inactiveTabPadding, 0, 0),
        child: Container(
          height: _bookmarkHeight,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(_getTabBookmark(tab)),
              fit: BoxFit.fill,
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

  String _getTabName(TabCode tabCode) => switch (tabCode) {
        TabCode.europe => tr('new_game_tab_europe'),
        TabCode.asia => tr('new_game_tab_asia'),
        TabCode.newWorld => tr('new_game_tab_new_world'),
      };

  String _getTabBookmark(TabCode tabCode) => switch (tabCode) {
    TabCode.europe => 'assets/images/screens/shared/bookmarks/bookmark_red_92.webp',
    TabCode.asia => 'assets/images/screens/shared/bookmarks/bookmark_blue_64.webp',
    TabCode.newWorld => 'assets/images/screens/shared/bookmarks/bookmark_green_131.webp',
  };
}
