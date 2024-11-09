part of map_selection_ui;

class _CardBanners extends StatelessWidget {
  final MapCardDto _card;

  final MapSelectionUserActions _userActions;

  static const _bannerSize = 50.0;
  static const _opponentSelectionWidth = 3.0;

  const _CardBanners({
    super.key,
    required MapCardDto card,
    required MapSelectionUserActions userActions,
  })  : _card = card,
        _userActions = userActions;

  @override
  Widget build(BuildContext context) {
    if (_card.neutrals.isEmpty) {
      return _getOpponents();
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _getOpponents(),
          _getBannersColumn(
            header: tr('new_game_neutrals'),
            body: _CardBannersNeutrals(
              neutrals: _card.neutrals,
              bannerSize: _bannerSize,
            ),
          ),
        ],
      );
    }
  }

  Widget _getBannersColumn({required String header, required Widget body}) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
            child: Text(
              header,
              style: AppTypography.s16w600,
            ),
          ),
          body,
        ],
      );

  Widget _getOpponents() => _getBannersColumn(
        header: tr('new_game_opponents'),
        body: _CardBannersOpponents(
          opponents: _card.opponents,
          bannerSize: _bannerSize,
          opponentSelectionWidth: _opponentSelectionWidth,
          selectedNation: _card.opponents.firstWhere((o) => o.selected).nation,
          cardId: _card.id,
          userActions: _userActions,
        ),
      );
}
