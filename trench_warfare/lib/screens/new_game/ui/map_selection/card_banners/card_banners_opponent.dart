/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of map_selection_ui;

class _CardBannersOpponent extends StatelessWidget {
  final Nation _nation;

  final double _bannerSize;

  final double _opponentSelectionWidth;

  final bool _selected;

  final String _cardId;

  final bool _completed;

  final MapSelectionUserActions _userActions;

  const _CardBannersOpponent({
    super.key,
    required Nation nation,
    required double bannerSize,
    required double opponentSelectionWidth,
    required bool selected,
    required String cardId,
    required bool completed,
    required MapSelectionUserActions userActions,
  })  : _nation = nation,
        _bannerSize = bannerSize,
        _opponentSelectionWidth = opponentSelectionWidth,
        _selected = selected,
        _cardId = cardId,
        _completed = completed,
        _userActions = userActions;

  @override
  Widget build(BuildContext context) {
    final audioController = context.read<AudioController>();

    if (_selected) {
      return _getBanner(_getSelectedBanner());
    } else {
      return GestureDetector(
        onTap: () {
          audioController.playSound(SoundType.buttonClick);
          _userActions.onCardSelected(_cardId);
          _userActions.onOpponentSelected(_cardId, _nation);
        },
        child: _getBanner(_getUnselectedBanner()),
      );
    }
  }

  Widget _getBanner(innerWidget) => Stack(alignment: AlignmentDirectional.center, children: [
        innerWidget,
        if (_completed)
          Image.asset(
            'assets/images/screens/new_game/golden_checkmark.webp',
            height: _bannerSize / 1.5,
            width: _bannerSize / 1.5,
            fit: BoxFit.scaleDown,
          ),
      ]);

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
