part of carriers_phase_library;

class _LoadingToCarrierTransition extends _TroopTransferTransition {
  final _StateLoadingToCarrier _state;

  _LoadingToCarrierTransition({required _StateLoadingToCarrier state}) : _state = state;

  @override
  Future<_TroopTransferState> process() {
    // TODO: implement process
    throw UnimplementedError();
  }
}