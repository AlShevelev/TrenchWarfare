/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of game_field_army_info;

class GameFieldArmyInfoPanel extends StatefulWidget {
  static const width = 250.0;
  static const height = 70.0;

  late final int _cellId;

  final GameFieldControlsArmyInfo armyInfo;

  final Nation nation;

  final double left;
  final double top;

  late final TextureAtlas _spritesAtlas;

  late final GameFieldForControls _gameField;

  late final bool _isCarrier;

  GameFieldArmyInfoPanel({
    super.key,
    required int cellId,
    required this.nation,
    required this.armyInfo,
    required this.left,
    required this.top,
    required TextureAtlas spritesAtlas,
    required GameFieldForControls gameField,
    required bool isCarrier,
  }) {
    _cellId = cellId;
    _spritesAtlas = spritesAtlas;
    _gameField = gameField;
    _isCarrier = isCarrier;
  }

  @override
  State<GameFieldArmyInfoPanel> createState() => _GameFieldArmyInfoPanelState();
}

class _GameFieldArmyInfoPanelState extends State<GameFieldArmyInfoPanel>
    implements GameFieldArmyInfoUnitsCache {
  final Map<String, Picture> _cachedUnitPictures = {};

  @override
  Picture? getUnitPicture(String key) => _cachedUnitPictures[key];

  @override
  void putUnitPicture(String key, Picture picture) => _cachedUnitPictures.addAll({key: picture});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.left,
      top: widget.top,
      width: GameFieldArmyInfoPanel.width,
      height: GameFieldArmyInfoPanel.height,
      child: Background(
        imagePath: 'assets/images/screens/game_field/main/panel_army_info.webp',
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
          child: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            child: ReorderableListView(
              scrollDirection: Axis.horizontal,
              buildDefaultDragHandles: false,
              children: <Widget>[
                for (var i = 0; i < widget.armyInfo.units.length; i++)
                  ReorderableDragStartListener(
                    key: UniqueKey(),
                    index: i,
                    child: GameFieldArmyInfoUnit(
                      unit: widget.armyInfo.units[i],
                      nation: widget.armyInfo.nation,
                      spritesAtlas: widget._spritesAtlas,
                      cache: this,
                    ),
                  ),
              ],
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  final Unit item = widget.armyInfo.units.removeAt(oldIndex);
                  widget.armyInfo.units.insert(newIndex, item);

                  widget._gameField.onResortUnits(
                    widget._cellId,
                    widget.armyInfo.units.map((u) => u.id).toList(growable: false),
                    isCarrier: widget._isCarrier,
                  );
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
