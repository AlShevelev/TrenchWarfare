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
    final banners = _opponents
        .mapIndexed((index, opponent) => Padding(
              padding: EdgeInsets.fromLTRB(index > 0 ? 2 : 0, 0, 0, 0),
              child: _CardBannersOpponent(
                key: ObjectKey(opponent.nation),
                nation: opponent.nation,
                bannerSize: _bannerSize,
                opponentSelectionWidth: _opponentSelectionWidth,
                selected: opponent.nation == _selectedNation,
                cardId: _cardId,
                userActions: _userActions,
              ),
            ))
        .toList(growable: false);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: banners,
    );
  }
}
