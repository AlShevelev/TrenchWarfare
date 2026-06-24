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

enum _PanelType {
  brief,
  pcOrTerrainModifier,
  army,
  pcOrTerrainModifierAndArmy,
}

class GameFieldCellInfoPanel extends StatelessWidget {
  final GameFieldControlsCellInfo cellInfo;

  final TexturePackerAtlas _spritesAtlas;

  final double left;
  final double top;

  late final _PanelType? _type;

  static const String _backgroundPath = 'assets/images/screens/game_field/main/';

  GameFieldCellInfoPanel(
      {super.key,
      required this.cellInfo,
      required this.left,
      required this.top,
      required TexturePackerAtlas spritesAtlas})
      : _spritesAtlas = spritesAtlas {
    _type = _getPanelType(cellInfo);
  }

  @override
  Widget build(BuildContext context) {
    return switch (_type) {
      _PanelType.brief => GameFieldCellInfoBrief(
          cellInfo: cellInfo,
          left: left,
          top: top,
          backgroundPath: _backgroundPath,
        ),
      _PanelType.pcOrTerrainModifier => GameFieldCellInfoPcOrTerrainModifier(
        cellInfo: cellInfo,
        spritesAtlas: _spritesAtlas,
        left: left,
        top: top,
        backgroundPath: _backgroundPath,
      ),
      _PanelType.army => GameFieldCellInfoArmy(
        cellInfo: cellInfo,
        spritesAtlas: _spritesAtlas,
        left: left,
        top: top,
        backgroundPath: _backgroundPath,
      ),
      _PanelType.pcOrTerrainModifierAndArmy => GameFieldCellInfoPcOrTerrainModifierWithArmy(
        cellInfo: cellInfo,
        spritesAtlas: _spritesAtlas,
        left: left,
        top: top,
        backgroundPath: _backgroundPath,
      ),
      _ => const SizedBox.shrink(),
    };
  }

  _PanelType? _getPanelType(GameFieldControlsCellInfo cellInfo) {
    if (cellInfo.units.isNotEmpty) {
      if (cellInfo.terrainModifier != null || cellInfo.productionCenter != null) {
        return _PanelType.pcOrTerrainModifierAndArmy;
      } else {
        return _PanelType.army;
      }
    } else {
      if (cellInfo.terrainModifier != null || cellInfo.productionCenter != null) {
        return _PanelType.pcOrTerrainModifier;
      } else {
        return _PanelType.brief;
      }
    }
  }
}
