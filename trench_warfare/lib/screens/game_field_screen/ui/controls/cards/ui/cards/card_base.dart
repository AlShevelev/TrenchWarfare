/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of card_controls;

abstract class _CardBase<T> extends StatelessWidget {
  @protected
  final _CardDto<T> _card;

  final _CardsSelectionUserActions _userActions;

  static const _imagesPath = 'assets/images/screens/game_field/cards/';

  const _CardBase({
    super.key,
    required _CardDto<T> card,
    required _CardsSelectionUserActions userActions,
  })  : _card = card,
        _userActions = userActions;

  @override
  Widget build(BuildContext context) {
    final audioController = context.read<AudioController>();

    return DefaultTextStyle(
      style: const TextStyle(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            if (!_card.selected && _card.canBuild) {
              audioController.playSound(SoundType.buttonClick);

              _userActions.onCardSelected(_card.indexInTab);
            }
          },
          child: Cardboard(
              style: _getCardStyle(),
              selected: _card.selected,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 6),
                      child: Text(
                        _getTitleText(),
                        style: AppTypography.s20w600,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                      child: Image.asset(_getPhoto()),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                      child: _getFeaturesPanel(),
                    ),
                    _getDescription(_getDescriptionText()),
                    _getFooter(
                      _getFooterMoney(),
                      _getFooterRestriction(),
                      audioController,
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  @protected
  CardboardStyle _getCardStyle();

  MoneyUnit _getFooterMoney() => _card.card.cost;

  BuildRestriction? _getFooterRestriction() => _card.card.buildDisplayRestriction;

  @protected
  Widget _getFooter(
    MoneyUnit money,
    BuildRestriction? restriction,
    AudioController audioController,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BuildRestrictionPanel(
          money: money,
          buildPossibility: _card.card,
        ),
        GestureDetector(
          onTap: () {
            audioController.playSound(SoundType.buttonClick);
            _userActions.onCardExpendedOrCollapsed(_card.indexInTab);
          },
          child: Image.asset(
            '$_imagesPath${!_card.expanded ? 'icon_expand.webp' : 'icon_collapse.webp'}',
            scale: 1.25,
          ),
        ),
      ],
    );
  }

  @protected
  Widget _getFeaturesPanel() => const SizedBox.shrink();

  @protected
  String _getTitleText();

  @protected
  String _getDescriptionText();

  Widget _getDescription(String text) {
    if (!_card.expanded) {
      return const SizedBox.shrink();
    } else {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
        child: Text(
          text,
          textAlign: TextAlign.justify,
          style: AppTypography.s14w400,
        ),
      );
    }
  }

  @protected
  String _getPhoto() => CardPhotos.getPhoto(_card.card);
}
