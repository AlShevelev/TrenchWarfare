/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

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
        _actions = PlayerActions(player: player, unitUpdateResultBridge: null) {
    // It's a dirty, but necessary hack
    final playerCore = _player as PlayerCore;
    playerCore.registerOnAnimationCompleted(() {
      _actions.canContinue();
    });

    _transfersStorage.setPlayerActions(_actions);
  }

  @override
  Future<void> start() async {
    final busyCarriersIds = _transfersStorage.allTransfers
        .where((t) => t.selectedCarrierId != null)
        .map((t) => t.selectedCarrierId);

    final List<Tuple2<Carrier, GameFieldCellRead>> freeCarriersCells = _gameField.cells
        .where((c) => c.nation == _myNation && c.units.isNotEmpty)
        .expand((c) => c.units
            .where((u) => u.type == UnitType.carrier && !busyCarriersIds.contains(u.id))
            .map((u) => Tuple2(u as Carrier , c)))
        .toList(growable: false);

    final calculator = CarriersTargetCalculatorBrief(
      gameField: _gameField,
      myNation: _myNation,
      metadata: _metadata,
    );

    for (var freeCarrier in freeCarriersCells) {
      final targetCell = calculator.getTarget(freeCarrier.item2);

      Logger.info('Target is: $targetCell', tag: 'CARRIER');

      // And have a target for them
      if (targetCell != null) {
        Logger.info('New transfer is added', tag: 'CARRIER');
        _transfersStorage.addNewTransfer(
          targetCell: targetCell,
          selectedCarrier: freeCarrier.item1,
        );
      }
    }

    await _transfersStorage.processAll();
    Logger.info('End the phase', tag: 'CARRIER');
  }
}
