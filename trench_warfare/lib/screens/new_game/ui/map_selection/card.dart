part of map_selection_ui;

class Card extends StatelessWidget {
  final bool _selected;

  final MapCardDto _card;

  final TabCode _tabCode;

  final MapSelectionUserActions _userActions;

  const Card({
    super.key,
    required bool selected,
    required TabCode tabCode,
    required MapCardDto card,
    required MapSelectionUserActions userActions,
  })  : _tabCode = tabCode,
        _card = card,
        _userActions = userActions,
        _selected = selected;

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
              _userActions.onCardSelected(_card.id);
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
                        _card.title[locale]!,
                        style: AppTypography.s20w600,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 3),
                      child: Text(
                        _getDatesText(),
                        style: AppTypography.s16w600,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                      child: Image.asset(_getPhoto()),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                      child: CardBanners(
                        card: _card,
                        userActions: _userActions,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(2, 0, 2, 3),
                      child: Text(
                        _card.description[locale]!,
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

  String _getBackgroundImage() => switch (_tabCode) {
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

    final from = _card.from;
    final to = _card.to;

    if (from.month == to.month && from.year == to.year) {
      return dateToText(from);
    } else {
      return '${dateToText(from)} - ${dateToText(to)}';
    }
  }

  String _getPhoto() =>
      'assets/images/screens/new_game/maps/${_tabCode.uiString}/${_card.mapName}.webp';
}
