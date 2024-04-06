part of game_field_cell_info;

class GameFieldCellInfoBrief extends StatelessWidget {
  final GameFieldControlsCellInfo cellInfo;

  const GameFieldCellInfoBrief({
    super.key,
    required this.cellInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _getTerrainName(cellInfo.terrain),
          overflow: TextOverflow.fade,
        ),
        _getMoneyWidget(),
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
          'assets/images/game_field_overlays/icon_money.webp',
          height: 18,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
          child: Text(
            cellInfo.income.currency < 10000 ? cellInfo.income.currency.toString() : tr('greater_10_k'),
            style: AppTypography.s20w600,
            overflow: TextOverflow.fade,
          ),
        ),
        const Spacer(),
        Image.asset(
          'assets/images/game_field_overlays/icon_industry_points.webp',
          height: 18,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
          child: Text(
            cellInfo.income.industryPoints < 10000 ? cellInfo.income.industryPoints.toString() : tr('greater_10_k'),
            style: AppTypography.s20w600,
            overflow: TextOverflow.fade,
          ),
        ),
      ],
    );
  }
}
