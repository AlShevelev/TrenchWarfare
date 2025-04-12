part of units_moving_phase_library;

class _ResortEstimationProcessor extends _UnitEstimationProcessorBase {
  _ResortEstimationProcessor({
    required super.actions,
    required super.influences,
    required super.unit,
    required super.cell,
    required super.myNation,
    required super.metadata,
    required super.gameField,
  });

  /// Returns a weight of the estimation. Zero value means - the estimation is impossible
  @override
  double _estimateInternal() {
    if (_unit.isInDefenceMode) {
      return 0;
    }

    if (_unit.type == UnitType.carrier) {
      return 0;
    }

    if (_cell.units.length <= 1 || _cell.activeUnit != _unit) {
      return 0;
    }

    if (_unit.health / _unit.maxHealth > 0.75) {
      return 0;
    }

    if (_unit.type == UnitType.artillery) {
      return _getWeightForArtillery();
    }

    if (!_unit.isMechanical) {
      return _getWeightForLive();
    }

    return 0;
  }

  @override
  Future<List<MovementResultItem>?> processAction() async {
    final firstId = _cell.activeUnit!.id;

    final cellUnitsIds = _cell.units.map((u) => u.id).toList(growable: true)
      ..removeAt(0)
      ..add(firstId);

    _actions.resort(_cell, cellUnitsIds);

    _unit.setState(UnitState.disabled);

    return null;
  }

  double _getWeightForArtillery() {
    if (_cell.units.elementAt(1).type == UnitType.artillery) {
      return 0;
    }

    final influenceCell = _influences.getItem(_cell.row, _cell.col);

    if (!_allEnemies.any((o) => influenceCell.hasAny(o))) {
      return 0;
    }

    final cellsAround = <GameFieldCell>[
      ..._gameField.findCellsAround(_cell),
      ..._gameField.findCellsAroundR(_cell, radius: 2),
      ..._gameField.findCellsAroundR(_cell, radius: 3)
    ];

    // The weight is a quantity of an enemy artillery units
    return IterableIntegerExtension(cellsAround
        .where((c) => c.nation != _myNation && c.units.isNotEmpty && _isEnemyCell(c))
        .map((c) => c.units.count((u) => u.hasArtillery))).sum.toDouble() + 1;
  }

  double _getWeightForLive() {
    if (!_cell.units.elementAt(1).isMechanical) {
      return 0;
    }

    final influenceCell = _influences.getItem(_cell.row, _cell.col);

    if (!_allEnemies.any((o) => influenceCell.hasAny(o))) {
      return 0;
    }

    final cellsAround = <GameFieldCell>[
      ..._gameField.findCellsAround(_cell),
      ..._gameField.findCellsAroundR(_cell, radius: 2),
      ..._gameField.findCellsAroundR(_cell, radius: 3)
    ];

    // The weight is a quantity of an enemy machine gunners
    return IterableIntegerExtension(cellsAround
        .where((c) => c.nation != _myNation && c.units.isNotEmpty && _isEnemyCell(c))
        .map((c) => c.units.count((u) => u.hasMachineGun))).sum.toDouble() + 1;
  }
}
