part of game_field_army_info;

class GameFieldArmyInfoPanel extends StatefulWidget {
  static const width = 250.0;
  static const height = 70.0;

  //final GameFieldControlsCellInfo cellInfo;

  late final TextureAtlas _spritesAtlas;

  final double left;
  final double top;

  GameFieldArmyInfoPanel({
    super.key,
    //required this.cellInfo,
    required this.left,
    required this.top,
    required TextureAtlas spritesAtlas,
  }) {
    _spritesAtlas = spritesAtlas;
  }

  @override
  State<GameFieldArmyInfoPanel> createState() => _GameFieldArmyInfoPanelState();
}

class _GameFieldArmyInfoPanelState extends State<GameFieldArmyInfoPanel> implements GameFieldArmyInfoUnitsCache {
  final List<Unit> _units = [
    Unit(
      boost1: UnitBoost.attack,
      boost2: UnitBoost.defence,
      boost3: UnitBoost.commander,
      experienceRank: UnitExperienceRank.proficients,
      fatigue: 1,
      health: 1,
      movementPoints: 10,
      type: UnitType.machineGuns,
    ),
    Unit(
      boost1: UnitBoost.attack,
      boost2: UnitBoost.defence,
      boost3: UnitBoost.commander,
      experienceRank: UnitExperienceRank.proficients,
      fatigue: 1,
      health: 1,
      movementPoints: 10,
      type: UnitType.infantry,
    )..setState(UnitState.disabled),
    Unit(
      boost1: UnitBoost.attack,
      boost2: UnitBoost.defence,
      boost3: UnitBoost.commander,
      experienceRank: UnitExperienceRank.proficients,
      fatigue: 1,
      health: 1,
      movementPoints: 10,
      type: UnitType.cavalry,
    ),
    Unit(
      boost1: UnitBoost.attack,
      boost2: UnitBoost.defence,
      boost3: UnitBoost.commander,
      experienceRank: UnitExperienceRank.proficients,
      fatigue: 1,
      health: 1,
      movementPoints: 10,
      type: UnitType.battleship,
    ),
  ];

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
        imagePath: 'assets/images/game_field_controls/panel_army_info.webp',
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
                for (var i = 0; i < _units.length; i++)
                  ReorderableDragStartListener(
                    key: UniqueKey(),
                    index: i,
                    child: GameFieldArmyInfoUnit(
                      unit: _units[i],
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
                  final Unit item = _units.removeAt(oldIndex);
                  _units.insert(newIndex, item);
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
