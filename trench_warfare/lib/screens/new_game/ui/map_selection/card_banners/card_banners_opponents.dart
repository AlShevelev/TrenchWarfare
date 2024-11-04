part of map_selection_ui;

class CardBannersOpponents extends StatefulWidget {
  final Iterable<SideOfConflictDto> _opponents;

  final double _bannerSize;

  final double _opponentSelectionWidth;

  const CardBannersOpponents({
    super.key,
    required Iterable<SideOfConflictDto> opponents,
    required double bannerSize,
    required double opponentSelectionWidth,
  })  : _opponents = opponents,
        _bannerSize = bannerSize,
        _opponentSelectionWidth = opponentSelectionWidth;

  @override
  State<StatefulWidget> createState() => _CardBannersOpponentsState();
}

class _CardBannersOpponentsState extends State<CardBannersOpponents> {
  late Nation _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget._opponents.firstWhere((o) => o.selected).nation;
  }

  @override
  Widget build(BuildContext context) {
    final banners = widget._opponents
        .mapIndexed((index, opponent) => Padding(
              padding: EdgeInsets.fromLTRB(index > 0 ? 2 : 0, 0, 0, 0),
              child: CardBannersOpponent(
                nation: opponent.nation,
                bannerSize: widget._bannerSize,
                opponentSelectionWidth: widget._opponentSelectionWidth,
                selected: opponent.selected,
                onNationSelected: (nation) {
                  _selected = nation;
                },
              ),
            ))
        .toList(growable: false);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: banners,
    );
  }
}
