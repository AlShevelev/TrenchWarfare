part of game_field_army_info;

class GameFieldArmyInfoPanel extends StatelessWidget {
  static const width = 250.0;
  static const height = 70.0;

  //final GameFieldControlsCellInfo cellInfo;

  late final TextureAtlas _spritesAtlas;

  final double left;
  final double top;

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
  Widget build(BuildContext context) {
    final widgets = List<Widget>.empty(growable: true);
    for (var i = 0; i < _units.length; i++) {
      widgets.add(
          Padding(
            padding: EdgeInsets.fromLTRB(i == 0 ? 0 : 10, 0, 0, 0),
            child: CustomPaint(
              painter: GameFieldArmyInfoUnitPainter(_units[i], Nation.austriaHungary, _spritesAtlas),
              child: const SizedBox(
                width: 50,
                height: 50,
                child: null,
              ),
            ),
          )
      );
    }

    return Positioned(
      left: left,
      top: top,
      width: width,
      height: height,
      child: Background(
        imagePath: 'assets/images/game_field_controls/panel_army_info.webp',
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: widgets,
          ),
        ),
      ),
    );
  }
}
