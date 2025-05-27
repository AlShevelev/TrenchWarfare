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

class _CardBannersNeutrals extends StatelessWidget {
  final Iterable<Nation> _neutrals;

  final double _bannerSize;

  const _CardBannersNeutrals({
    super.key,
    required Iterable<Nation> neutrals,
    required double bannerSize,
  })  : _neutrals = neutrals,
        _bannerSize = bannerSize;

  @override
  Widget build(BuildContext context) {
    final banners = _neutrals
        .mapIndexed(
          (index, neutral) => Positioned(
            right: index * _bannerSize / 2,
            width: _bannerSize,
            height: _bannerSize,
            child: Image.asset(
              neutral.image,
              height: _bannerSize,
              width: _bannerSize,
              fit: BoxFit.cover,
            ),
          ),
        )
        .toList(growable: false);

    return SizedBox(
        width: _bannerSize + (_bannerSize / 2) * (_neutrals.length - 1),
        height: _bannerSize,
        child: Stack(children: banners),
    );
  }
}
