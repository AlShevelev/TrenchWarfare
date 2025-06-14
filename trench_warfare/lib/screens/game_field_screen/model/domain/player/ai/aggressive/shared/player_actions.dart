/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of aggressive_ai_shared_library;

class PlayerActions {
  static const _pauseToRedraw = 100;

  final PlayerInput _player;

  final UnitUpdateResultBridgeRead? _unitUpdateResultBridge;

  AsyncSignal? _signal;

  PlayerActions({
    required PlayerInput player,
    required UnitUpdateResultBridgeRead? unitUpdateResultBridge,
  })  : _player = player,
        _unitUpdateResultBridge = unitUpdateResultBridge;

  Future<List<UnitUpdateResultItem>?> move(
    Unit unit, {
    required GameFieldCellRead from,
    required GameFieldCellRead to,
  }) async {
    _signal?.unlockAndClose();
    _signal = AsyncSignal(locked: true);

    if (from.id == to.id) {
      return null;
    }

    if (from.activeUnit != unit) {
      final resortedUnitIds = <String>[unit.id, ...from.units.where((u) => u != unit).map((u) => u.id)];
      resort(from, resortedUnitIds);
    }

    _player.onClick(from.center); // select a unit...

    // We have to add a tiny pause here to let the updated cells to redraw.
    // Without the pause we'll get some weird visual effects due to redraw
    // race conditions
    await Future.delayed(const Duration(milliseconds: _pauseToRedraw));

    _player.onClick(to.center); // make a path...

    await Future.delayed(const Duration(milliseconds: _pauseToRedraw));

    _player.onClick(to.center); // go!

    await _signal?.wait(); // waiting for animation to complete

    return _unitUpdateResultBridge?.extractResult();
  }

  void resort(GameFieldCellRead cell, Iterable<String> unitIds) =>
      _player.onResortUnits(cell.id, unitIds, isCarrier: false);

  void canContinue() {
    _signal?.unlockAndClose();
    _signal = null;
  }
}
