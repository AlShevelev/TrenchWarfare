part of carriers_phase_library;

class CarriersPhase implements TurnPhase {
  final PlayerInput _player;

  final GameFieldRead _gameField;

  final Nation _myNation;

  final MapMetadataRead _metadata;

  final CarrierTroopTransfersStorage _transfersStorage;

  final PlayerActions _actions;

  CarriersPhase(
      {required GameFieldRead gameField,
      required PlayerInput player,
      required Nation myNation,
      required MapMetadataRead metadata,
      required CarrierTroopTransfersStorage transfersStorage})
      : _gameField = gameField,
        _player = player,
        _myNation = myNation,
        _metadata = metadata,
        _transfersStorage = transfersStorage,
        _actions = PlayerActions(player: player) {
    // It's a dirty, but necessary hack
    final playerCore = _player as PlayerCore;
    playerCore.registerOnAnimationCompleted(() {
      _actions.onAnimationCompleted();
    });

    _transfersStorage.setPlayerActions(_actions);
  }

  @override
  Future<void> start() async {
    final carriersCount = _gameField.cells
        .where((c) => c.nation == _myNation && c.units.isNotEmpty)
        .map((c) => c.units.count((u) => u.type == UnitType.carrier))
        .sum;

    // We've got free carriers
    if (carriersCount > _transfersStorage.totalTransfers) {
      final target = CarriersTargetCalculator(
        gameField: _gameField,
        myNation: _myNation,
        metadata: _metadata,
      ).getTarget();

      // And have a target for them
      if (target != null) {
        _transfersStorage.addNewTransfer(targetCell: target);
      }
    }

    await _transfersStorage.processAll();
  }
}
