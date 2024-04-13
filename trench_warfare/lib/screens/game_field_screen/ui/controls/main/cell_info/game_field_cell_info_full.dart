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
            MoneyPanel(money: cellInfo.income, smallFont: true, stretch: false,),
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
}
