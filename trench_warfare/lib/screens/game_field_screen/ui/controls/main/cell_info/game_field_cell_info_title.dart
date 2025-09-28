/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of game_field_cell_info;

class GameFieldCellInfoTitle extends StatelessWidget {
  final GameFieldControlsCellInfo cellInfo;

  static const _bannerSize = 20.0;

  const GameFieldCellInfoTitle({
    super.key,
    required this.cellInfo,
  });

  @override
  Widget build(BuildContext context) {
    final banner = _getBanner();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if(banner != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
            child: Image.asset(
              banner,
              width: _bannerSize,
              height: _bannerSize,
            ),
          ),
        Text(
          _getTerrainName(cellInfo.terrain),
          style: AppTypography.s18w600,
          overflow: TextOverflow.fade,
        ),
      ],
    );
  }

  String _getTerrainName(CellTerrain terrain) {
    return switch (terrain) {
      CellTerrain.plain => tr('plain'),
      CellTerrain.wood => tr('wood'),
      CellTerrain.marsh => tr('marsh'),
      CellTerrain.sand => tr('sand'),
      CellTerrain.hills => tr('hills'),
      CellTerrain.mountains => tr('mountains'),
      CellTerrain.snow => tr('snow'),
      CellTerrain.water => tr('water'),
    };
  }

  String? _getBanner() => cellInfo.nation?.let(
        (n) => 'assets/images/screens/game_field/banners/${n.name}.webp',
      );
}
