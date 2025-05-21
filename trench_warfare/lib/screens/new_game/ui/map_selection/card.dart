part of map_selection_ui;

class _Card extends StatelessWidget {
  final bool _selected;

  final MapCardDto _card;

  final TabCode _tabCode;

  final MapSelectionUserActions _userActions;

  final int _mapRows;
  final int _mapCols;

  static const _imagesPath = 'assets/images/screens/game_field/cards/';

  const _Card({
    super.key,
    required bool selected,
    required TabCode tabCode,
    required MapCardDto card,
    required MapSelectionUserActions userActions,
    required int mapCols,
    required int mapRows,
  })  : _tabCode = tabCode,
        _card = card,
        _userActions = userActions,
        _selected = selected,
        _mapRows = mapRows,
        _mapCols = mapCols;

  @override
  Widget build(BuildContext context) {
    final locale = AppLocale.fromString((localization.EasyLocalization.of(context)?.locale.toString())!);

    final audioController = context.read<AudioController>();

    return DefaultTextStyle(
      style: const TextStyle(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            if (!_selected) {
              audioController.playSound(SoundType.buttonClick);
              _userActions.onCardSelected(_card.id);
            }
          },
          child: Cardboard(
              selected: _selected,
              style: _getCardStyle(),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 3),
                      child: Text(
                        _card.title[locale]!,
                        style: AppTypography.s20w600,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 6),
                      child: Text(
                        _getDatesText(),
                        style: AppTypography.s16w600,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                      child: Image.asset(_getPhoto()),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                      child: _CardBanners(
                        card: _card,
                        userActions: _userActions,
                      ),
                    ),
                    if (_card.expanded)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(2, 0, 2, 10),
                        child: Text(
                          _card.description[locale]!,
                          style: AppTypography.s14w400,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, _card.expanded ? 0 : 10, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${tr('new_game_map_size')}: ${_getMapSize()}',
                            style: AppTypography.s16w600,
                            textAlign: TextAlign.end,
                          ),
                          GestureDetector(
                            onTap: () {
                              audioController.playSound(SoundType.buttonClick);
                              _userActions.onCardExpanded(_card.id);
                            },
                            child: Image.asset(
                              '$_imagesPath${!_card.expanded ? 'icon_expand.webp' : 'icon_collapse.webp'}',
                              scale: 1.25,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  CardboardStyle _getCardStyle() => switch (_tabCode) {
        TabCode.europe => CardboardStyle.red,
        TabCode.asia => CardboardStyle.blue,
        TabCode.newWorld => CardboardStyle.green,
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

  String _getPhoto() => 'assets/images/screens/new_game/maps/${_tabCode.uiString}/${_card.mapName}.webp';

  String _getMapSize() => switch (_mapRows * _mapCols) {
        <= 100 => tr('new_game_tiny'), // 10x10
        <= 225 => tr('new_game_small'), // 15x15
        <= 400 => tr('new_game_medium'), // 20x20
        <= 625 => tr('new_game_large'), // 25x25
        _ => tr('new_game_huge')
      };
}
