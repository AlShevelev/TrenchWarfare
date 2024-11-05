part of map_selection_ui;

typedef _OnNationSelected = void Function(Nation);

class CardBannersOpponent extends StatelessWidget {
  final Nation _nation;

  final double _bannerSize;

  final double _opponentSelectionWidth;

  final bool _selected;

  final _OnNationSelected _onNationSelected;

  const CardBannersOpponent({
    super.key,
    required Nation nation,
    required double bannerSize,
    required double opponentSelectionWidth,
    required bool selected,
    required _OnNationSelected onNationSelected,
  })  : _nation = nation,
        _bannerSize = bannerSize,
        _opponentSelectionWidth = opponentSelectionWidth,
        _selected = selected,
        _onNationSelected = onNationSelected;

  @override
  Widget build(BuildContext context) {
    if (_selected) {
      return _getSelectedBanner();
    } else {
      return GestureDetector(
        onTap: () {
          _onNationSelected(_nation);
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
      borderRadius: BorderRadius.all( Radius.circular(_bannerSize)),
      border: Border.all(
        color: AppColors.yellow,
        width: _opponentSelectionWidth,
      ),
    ),
  );
}
