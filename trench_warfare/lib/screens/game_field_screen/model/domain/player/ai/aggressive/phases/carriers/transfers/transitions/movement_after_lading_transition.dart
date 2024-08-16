part of carriers_phase_library;

class _MovementAfterLadingTransition extends _TroopTransferTransition {
  final _TroopTransferStateMovementAfterLanding _state;

  _MovementAfterLadingTransition({required _TroopTransferStateMovementAfterLanding state}) : _state = state;

  @override
  Future<_TroopTransferState> process() {
    // TODO: implement process
    throw UnimplementedError();
  }
}