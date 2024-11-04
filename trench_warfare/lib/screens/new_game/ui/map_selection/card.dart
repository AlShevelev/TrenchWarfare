part of map_selection_ui;

class Card extends StatefulWidget {
  final ValueNotifier<bool> _selected = ValueNotifier(false);

  final MapCardDto _card;

  final TabCode _tabCode;

  final int _index;

  final _OnMapClick _onClick;

  Card({
    super.key,
    required bool selected,
    required TabCode tabCode,
    required MapCardDto card,
    required int index,
    required _OnMapClick onClick,
  })  : _onClick = onClick,
        _tabCode = tabCode,
        _card = card,
        _index = index {
    _selected.value = selected;
  }

  void updateSelection(bool selected) => _selected.value = selected;

  @override
  State<StatefulWidget> createState() => _CardState();
}

class _CardState extends State<Card> {
  static const _imagesPath = 'assets/images/screens/game_field/cards/';

  bool _selected = false;

  @override
  void initState() {
    super.initState();
    _selected = widget._selected.value;

    widget._selected.addListener(() {
      if (mounted) {
        setState(() {
          _selected = widget._selected.value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocale.fromString((localization.EasyLocalization.of(context)?.locale.toString())!);

    final List<BoxShadow> shadow = [];
    if (_selected) {
      shadow.add(
        const BoxShadow(
          color: AppColors.black,
          spreadRadius: 3,
          blurRadius: 5,
          offset: Offset(0, 3), // changes position of shadow
        ),
      );
    }

    return DefaultTextStyle(
      style: const TextStyle(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            if (!_selected) {
              widget._onClick(widget._index);
            }
          },
          child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(_getBackgroundImage()),
                  fit: BoxFit.fill,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                boxShadow: shadow,
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 3),
                      child: Text(
                        widget._card.title[locale]!,
                        style: AppTypography.s20w600,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 3),
                      child: Text(
                        _getDatesText(),
                        style: AppTypography.s18w600,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                      child: Image.asset(_getPhoto()),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                      child: CardBanners(card: widget._card,),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(2, 0, 2, 3),
                      child: Text(
                        widget._card.description[locale]!,
                        style: AppTypography.s14w400,
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  String _getBackgroundImage() => switch (widget._tabCode) {
        TabCode.europe => 'assets/images/screens/shared/card_red_background.webp',
        TabCode.asia => 'assets/images/screens/shared/card_blue_background.webp',
        TabCode.newWorld => 'assets/images/screens/shared/card_green_background.webp',
      };

  String _getDatesText() {
    String dateToText(DateTime date) {
      final month = switch (date.month) {
        1 => 'january',
        2 => 'february',
        3 => 'march',
        4 => 'april',
        5 => 'may',
        6 => 'june',
        7 => 'july',
        8 => 'august',
        9 => 'september',
        10 => 'october',
        11 => 'november',
        12 => 'december',
        _ => '',
      };

      return '${tr(month)} ${date.year}';
    }

    final from = widget._card.from;
    final to = widget._card.from;

    if (from.month == to.month && from.year == to.year) {
      return dateToText(from);
    } else {
      return '${dateToText(from)} - ${dateToText(to)}';
    }
  }

  String _getPhoto() =>
      'assets/images/screens/new_game/maps/${widget._tabCode.uiString}/${widget._card.id}.webp';
}
