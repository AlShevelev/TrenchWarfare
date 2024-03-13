part of game_field_cell_info;

class GameFieldCellInfoFull extends StatelessWidget {
  final GameFieldControlsCellInfo cellInfo;

  late final TextureAtlas _spritesAtlas;

  GameFieldCellInfoFull({
    super.key,
    required this.cellInfo,
    required TextureAtlas spritesAtlas
  }) {
    _spritesAtlas = spritesAtlas;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _getTerrainName(cellInfo.terrain),
              style: AppTypography.s18w600,
              overflow: TextOverflow.fade,
            ),
            _getMoneyWidget()
          ],
        ),
        Expanded(
          child: CustomPaint(
            painter: GameFieldCellInfoGameObjectPainter(cellInfo, _spritesAtlas),
            child: Container(
              child: null,
            ),
          ),
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

  Widget _getMoneyWidget() {
    return Row(
      children: [
        Image.asset(
          'assets/images/game_field_controls/icon_money.webp',
          height: 16,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(2, 0, 8, 0),
          child: Text(
            cellInfo.money < 10000 ? cellInfo.money.toString() : tr('greater_10_k'),
            style: AppTypography.s18w600,
            overflow: TextOverflow.fade,
          ),
        ),
        Image.asset(
          'assets/images/game_field_controls/icon_industry_points.webp',
          height: 16,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(2, 0, 4, 0),
          child: Text(
            cellInfo.industryPoints < 10000 ? cellInfo.industryPoints.toString() : tr('greater_10_k'),
            style: AppTypography.s18w600,
            overflow: TextOverflow.fade,
          ),
        ),
      ],
    );
  }
}
