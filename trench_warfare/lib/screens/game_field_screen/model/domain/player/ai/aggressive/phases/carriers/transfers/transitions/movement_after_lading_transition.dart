part of carriers_phase_library;

class _MovementAfterLadingTransition extends _TroopTransferTransition {
  final _StateMovementAfterLanding _state;

  _MovementAfterLadingTransition({required _StateMovementAfterLanding state}) : _state = state;

  @override
  Future<_TransitionResult> process() {
    // TODO: implement process
    throw UnimplementedError();
  }
}