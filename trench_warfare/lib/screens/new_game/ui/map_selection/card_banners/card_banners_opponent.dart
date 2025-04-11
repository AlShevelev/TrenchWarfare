part of map_selection_ui;

class _CardBannersOpponent extends StatelessWidget {
  final Nation _nation;

  final double _bannerSize;

  final double _opponentSelectionWidth;

  final bool _selected;

  final String _cardId;

  final MapSelectionUserActions _userActions;

  const _CardBannersOpponent({
    super.key,
    required Nation nation,
    required double bannerSize,
    required double opponentSelectionWidth,
    required bool selected,
    required String cardId,
    required MapSelectionUserActions userActions,
  })  : _nation = nation,
        _bannerSize = bannerSize,
        _opponentSelectionWidth = opponentSelectionWidth,
        _selected = selected,
        _cardId = cardId,
        _userActions = userActions;

  @override
  Widget build(BuildContext context) {
    final audioController = context.read<AudioController>();

    if (_selected) {
      return _getSelectedBanner();
    } else {
      return GestureDetector(
        onTap: () {
          audioController.playSound(SoundType.buttonClick);
          _userActions.onCardSelected(_cardId);
          _userActions.onOpponentSelected(_cardId, _nation);
        },
        child: _getUnselectedBanner(),
      );
    }
  }

  Widget _getUnselectedBanner() => Padding(
        padding: EdgeInsets.all(_opponentSelectionWidth),
        child: Image.asset(
          _nation.image,
          color: AppColors.halfLight,
          colorBlendMode: BlendMode.srcATop,
          height: _bannerSize,
          fit: BoxFit.fitHeight,
        ),
      );

  Widget _getSelectedBanner() => Container(
        width: _bannerSize + _opponentSelectionWidth * 2,
        height: _bannerSize + _opponentSelectionWidth * 2,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(_nation.image),
            fit: BoxFit.scaleDown,
          ),
          borderRadius: BorderRadius.all(Radius.circular(_bannerSize)),
          border: Border.all(
            color: AppColors.yellow,
            width: _opponentSelectionWidth,
          ),
        ),
      );
}
