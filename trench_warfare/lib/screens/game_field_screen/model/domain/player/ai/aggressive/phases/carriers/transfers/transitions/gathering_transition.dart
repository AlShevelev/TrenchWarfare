part of carriers_phase_library;

class _GatheringTransition extends _TroopTransferTransition {
  final _TroopTransferStateGathering _state;

  _GatheringTransition({required _TroopTransferStateGathering state}) : _state = state;

  @override
  Future<_TroopTransferState> process() {
    // TODO: implement process
    throw UnimplementedError();
  }
}