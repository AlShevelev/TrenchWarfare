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
    Logger.info('Start the phase', tag: 'CARRIER');
    final carriersCount = _gameField.cells
        .where((c) => c.nation == _myNation && c.units.isNotEmpty)
        .map((c) => c.units.count((u) => u.type == UnitType.carrier))
        .sum;

    Logger.info(
      'Carriers count: $carriersCount; Total transfers: ${_transfersStorage.totalTransfers}',
      tag: 'CARRIER',
    );

    // We've got free carriers
    if (carriersCount > _transfersStorage.totalTransfers) {
      final target = CarriersTargetCalculator(
        gameField: _gameField,
        myNation: _myNation,
        metadata: _metadata,
      ).getTarget();

      Logger.info('Target is: $target', tag: 'CARRIER');

      // And have a target for them
      if (target != null) {
        Logger.info('New transfer is added', tag: 'CARRIER');
        _transfersStorage.addNewTransfer(targetCell: target);
      }
    }

    await _transfersStorage.processAll();
    Logger.info('End the phase', tag: 'CARRIER');
  }
}
