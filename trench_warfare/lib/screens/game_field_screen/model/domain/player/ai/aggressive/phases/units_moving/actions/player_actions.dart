part of units_moving_phase_library;

class _PlayerActions {
  final PlayerInput _player;

  late AsyncSignal _signal;

  _PlayerActions({required PlayerInput player}) : _player = player;

  Future<void> move(Unit unit, {required GameFieldCellRead from, required GameFieldCellRead to}) async {
    if (from.activeUnit != unit) {
      final resortedUnitIds = <String>[unit.id, ...from.units.where((u) => u != unit).map((u) => u.id)];
      resort(from, resortedUnitIds);
    }

    _signal = AsyncSignal(locked: true);

    _player.onClick(from.center);   // select a unit...
    _player.onClick(to.center);     // make a path...
    _player.onClick(to.center);     // go!

    await _signal.wait();           // waiting for animation to complete
  }

  void resort(GameFieldCellRead cell, Iterable<String> unitIds) =>
      _player.onResortUnits(cell.id, unitIds, isCarrier: false);

  void onAnimationCompleted() {
    _signal.unlock();
    _signal.close();
  }
}