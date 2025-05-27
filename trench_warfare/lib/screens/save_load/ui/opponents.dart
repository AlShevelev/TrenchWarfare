/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of save_load_screen;

class _Opponents extends StatelessWidget {
  final Iterable<_SideOfConflictDto> _opponents;

  static const _bannerSize = 50.0;
  static const _opponentSelectionWidth = 3.0;

  const _Opponents({
    super.key,
    required Iterable<_SideOfConflictDto> opponents,
  })  : _opponents = opponents;

  @override
  Widget build(BuildContext context) {
    final banners = _opponents
        .mapIndexed((index, opponent) => Padding(
      padding: EdgeInsets.fromLTRB(index > 0 ? 2 : 0, 0, 0, 0),
      child: _Opponent(
        key: ObjectKey(opponent.nation),
        nation: opponent.nation,
        bannerSize: _bannerSize,
        opponentSelectionWidth: _opponentSelectionWidth,
        selected: opponent.selected,
      ),
    ))
        .toList(growable: false);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: banners,
    );
  }
}
