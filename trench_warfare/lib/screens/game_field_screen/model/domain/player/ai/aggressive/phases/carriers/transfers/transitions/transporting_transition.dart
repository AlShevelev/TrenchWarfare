part of carriers_phase_library;

class _TransportingTransition extends _TroopTransferTransition {
  final _TroopTransferStateTransporting _state;

  _TransportingTransition({required _TroopTransferStateTransporting state}) : _state = state;

  @override
  Future<_TroopTransferState> process() {
    // TODO: implement process
    throw UnimplementedError();
  }
}