part of map_selection_ui;

typedef _OnNationSelected = void Function(Nation);

class CardBannersOpponent extends StatefulWidget {
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
  State<StatefulWidget> createState() => _CardBannersOpponentState();
}

class _CardBannersOpponentState extends State<CardBannersOpponent> {
  late bool _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget._selected;
  }

  @override
  Widget build(BuildContext context) {
    if (_selected) {
      return _getSelectedBanner();
    } else {
      return GestureDetector(
        onTap: () {
          setState(() {
            _selected = true;
          });
          widget._onNationSelected(widget._nation);
        },
        child: _getUnselectedBanner(),
      );
    }
  }

  Widget _getUnselectedBanner() => Padding(
        padding: EdgeInsets.all(widget._opponentSelectionWidth),
        child: Image.asset(
          widget._nation.image,
          color: AppColors.halfLight,
          colorBlendMode: BlendMode.srcATop,
          height: widget._bannerSize,
          fit: BoxFit.fitHeight,
        ),
      );

  Widget _getSelectedBanner() => Container(
    width: widget._bannerSize + widget._opponentSelectionWidth * 2,
    height: widget._bannerSize + widget._opponentSelectionWidth * 2,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage(widget._nation.image),
        fit: BoxFit.scaleDown,
      ),
      borderRadius: BorderRadius.all( Radius.circular(widget._bannerSize)),
      border: Border.all(
        color: AppColors.yellow,
        width: widget._opponentSelectionWidth,
      ),
    ),
  );
}
