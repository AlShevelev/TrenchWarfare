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

class _CardBannersOpponents extends StatelessWidget {
  final Iterable<SideOfConflictDto> _opponents;

  final double _bannerSize;

  final double _opponentSelectionWidth;

  final Nation _selectedNation;

  final String _cardId;

  final MapSelectionUserActions _userActions;

  const _CardBannersOpponents({
    super.key,
    required Iterable<SideOfConflictDto> opponents,
    required double bannerSize,
    required double opponentSelectionWidth,
    required Nation selectedNation,
    required String cardId,
    required MapSelectionUserActions userActions,
  })  : _opponents = opponents,
        _bannerSize = bannerSize,
        _opponentSelectionWidth = opponentSelectionWidth,
        _selectedNation = selectedNation,
        _cardId = cardId,
        _userActions = userActions;

  @override
  Widget build(BuildContext context) {
    final banners = <Widget>[];

    var groupId = -1;

    for (var i = 0; i < _opponents.length; i++) {
      final opponent = _opponents.elementAt(i);

      var newGroupStarted = i != 0 && opponent.groupId != groupId;
      groupId = opponent.groupId;

      final padding = newGroupStarted
          ? 20.0
          : i > 0
              ? 0.0
              : 0.0;

      banners.add(Padding(
        padding: EdgeInsets.fromLTRB(padding, 0, 0, 0),
        child: _CardBannersOpponent(
          key: ObjectKey(opponent.nation),
          nation: opponent.nation,
          bannerSize: _bannerSize,
          opponentSelectionWidth: _opponentSelectionWidth,
          selected: opponent.nation == _selectedNation,
          cardId: _cardId,
          userActions: _userActions,
        ),
      ));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: banners,
    );
  }
}
