part of aggressive_player_ai;

sealed class TroopTransferState { }

class TroopTransferStateInit extends TroopTransferState { }

class TroopTransferStateGathering extends TroopTransferState { }

class TroopTransferStateTransporting extends TroopTransferState { }

class TroopTransferStateLanding extends TroopTransferState { }

class TroopTransferStateMovementAfterLanding extends TroopTransferState { }

class TroopTransferStateCompleted extends TroopTransferState { }
