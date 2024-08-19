part of carriers_phase_library;

class _LandingTransition extends _TroopTransferTransition {
  final _StateLanding _state;

  _LandingTransition({
    required super.actions,
    required super.gameField,
    required super.myNation,
    required _StateLanding state,
  }) : _state = state;

  @override
  Future<_TransitionResult> process() async {
    // TODO: implement process
    throw UnimplementedError();
  }
}
