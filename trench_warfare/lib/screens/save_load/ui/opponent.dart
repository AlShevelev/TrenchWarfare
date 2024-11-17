part of save_load_screen;

class _Opponent extends StatelessWidget {
  final Nation _nation;

  final double _bannerSize;

  final double _selectionWidth;

  final bool _selected;

  const _Opponent({
    super.key,
    required Nation nation,
    required double bannerSize,
    required double opponentSelectionWidth,
    required bool selected,
  })  : _nation = nation,
        _bannerSize = bannerSize,
        _selectionWidth = opponentSelectionWidth,
        _selected = selected;

  @override
  Widget build(BuildContext context) {
    if (_selected) {
      return _getSelectedBanner();
    } else {
      return _getUnselectedBanner();
    }
  }

  Widget _getUnselectedBanner() => Padding(
    padding: EdgeInsets.all(_selectionWidth),
    child: Image.asset(
      _nation.image,
      color: AppColors.halfLight,
      colorBlendMode: BlendMode.srcATop,
      height: _bannerSize,
      fit: BoxFit.fitHeight,
    ),
  );

  Widget _getSelectedBanner() => Container(
    width: _bannerSize + _selectionWidth * 2,
    height: _bannerSize + _selectionWidth * 2,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage(_nation.image),
        fit: BoxFit.scaleDown,
      ),
      borderRadius: BorderRadius.all(Radius.circular(_bannerSize)),
      border: Border.all(
        color: AppColors.yellow,
        width: _selectionWidth,
      ),
    ),
  );
}
