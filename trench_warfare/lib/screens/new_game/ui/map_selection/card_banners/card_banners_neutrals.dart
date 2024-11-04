part of map_selection_ui;

class CardBannersNeutrals extends StatelessWidget {
  final Iterable<Nation> _neutrals;

  final double _bannerSize;

  const CardBannersNeutrals({
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
