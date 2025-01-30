part of game_field_sm;

class FromStartTurnConfirmationOnStarTurnConfirmed {
  static const partOfHealthRestoredWithoutProductionCenter = 0.2;
  static const partOfHealthRestoredWithProductionCenter = 0.4;

  final GameFieldStateMachineContext _context;

  late final TransitionUtils _transitionUtils = TransitionUtils(_context);

  FromStartTurnConfirmationOnStarTurnConfirmed(this._context);

  State process() {
    _context.money.recalculateIncomeAndSum();

    final List<UpdateGameEvent> events = [];

    final cellsToIterate = _context.gameField.cells
        .where((c) => c.nation == _context.nation && c.units.isNotEmpty)
        .toList(growable: false);

    RandomGen.shiftItems(cellsToIterate);

    for (var cell in cellsToIterate) {
      final unitsToRemove = <Unit>[];

      for (var unit in cell.units) {
        _updateUnit(unit, cell.productionCenter?.type);

        if (unit is Carrier) {
          for (var unitInCarrier in unit.units) {
            _updateUnit(unitInCarrier, null);
          }
        }

        final totalSum = _context.money.totalSum;
        final unitExpense = MoneyUnitsCalculator.calculateExpense(unit);

        // We haven't got enough money to support a unit - let's dismiss it
        if (unitExpense.currency > totalSum.currency ||
            unitExpense.industryPoints > totalSum.industryPoints) {
          unitsToRemove.add(unit);
        }
        _context.money.reduceTotalSum(unitExpense);
      }

      cell.removeUnits(unitsToRemove);

      events.add(UpdateCell(cell, updateBorderCells: []));
    }

    _context.money.recalculateExpenses();

    _transitionUtils.setCameraPosition(events);

    _context.updateGameObjectsEvent.update(events);

    _context.controlsState.update(
      MainControls(
        totalSum: _context.money.totalSum,
        cellInfo: null,
        armyInfo: null,
        carrierInfo: null,
        nation: _context.nation,
      ),
    );

    return ReadyForInput();
  }

  void _updateUnit(Unit unit, ProductionCenterType? cellProductionCenter) {
    unit.setFatigue(unit.maxFatigue);
    unit.setMovementPoints(unit.maxMovementPoints);
    unit.setState(UnitState.enabled);

    final healthFactor = (unit.isMechanical && cellProductionCenter == ProductionCenterType.factory) ||
            (!unit.isMechanical && cellProductionCenter == ProductionCenterType.city) ||
            (unit.isShip && cellProductionCenter == ProductionCenterType.navalBase)
        ? partOfHealthRestoredWithProductionCenter
        : partOfHealthRestoredWithoutProductionCenter;

    final healthToAdd = unit.maxHealth * healthFactor;
    unit.setHealth(math.min(unit.health + healthToAdd, unit.maxHealth));
  }
}
