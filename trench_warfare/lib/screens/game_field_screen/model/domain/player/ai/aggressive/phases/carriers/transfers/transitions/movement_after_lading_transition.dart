part of carriers_phase_library;

class _MovementAfterLadingTransition extends _TroopTransferTransition {
  final _StateMovementAfterLanding _state;

  _MovementAfterLadingTransition({
    required _StateMovementAfterLanding state,
    required super.actions,
    required super.gameField,
    required super.myNation,
  }) : _state = state;

  @override
  Future<_TransitionResult> process() async {
    // TODO: implement process
    throw UnimplementedError();
  }
}
