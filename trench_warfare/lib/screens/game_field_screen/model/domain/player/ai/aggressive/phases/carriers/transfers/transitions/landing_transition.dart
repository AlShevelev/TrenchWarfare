part of carriers_phase_library;

class _LandingTransition extends _TroopTransferTransition {
  final _TroopTransferStateLanding _state;

  _LandingTransition({required _TroopTransferStateLanding state}) : _state = state;

  @override
  Future<_TroopTransferState> process() {
    // TODO: implement process
    throw UnimplementedError();
  }
}