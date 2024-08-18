part of carriers_phase_library;

class _LandingTransition extends _TroopTransferTransition {
  final _StateLanding _state;

  _LandingTransition({required _StateLanding state}) : _state = state;

  @override
  Future<_TransitionResult> process() {
    // TODO: implement process
    throw UnimplementedError();
  }
}