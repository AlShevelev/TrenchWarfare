part of game_field_cell_info;

class GameFieldCellInfoPanel extends StatelessWidget {
  static const _width = 162.0;
  static const _height = 83.0;

  final GameFieldControlsCellInfo cellInfo;

  final double left;
  final double top;

  const GameFieldCellInfoPanel({
    super.key,
    required this.cellInfo,
    required this.left,
    required this.top,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      width: _width,
      height: _height,
      child: Background(
          imagePath: 'assets/images/game_field_controls/panel_cell_info.webp',
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 10, 8, 18),
            child: DefaultTextStyle(
              style: AppTypography.s20w600,
              child: cellInfo.terrainModifier == null && cellInfo.productionCenter == null
                  ? GameFieldCellInfoBrief(cellInfo: cellInfo)
                  : GameFieldCellInfoFull(cellInfo: cellInfo)
            ),
          )),
    );
  }
}
