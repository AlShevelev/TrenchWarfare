/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of game_builders;

class TroopTransferReadForSavingImpl implements TroopTransferReadForSaving {
  @override
  final LandingPoint? gatheringPoint;

  @override
  final String id;

  @override
  final LandingPoint? landingPoint;

  @override
  final String? selectedCarrierId;

  @override
  final String stateAlias;

  @override
  final GameFieldCellRead targetCell;

  @override
  final List<Unit> transportingUnits;

  TroopTransferReadForSavingImpl({
    required this.gatheringPoint,
    required this.id,
    required this.landingPoint,
    required this.selectedCarrierId,
    required this.stateAlias,
    required this.targetCell,
    required this.transportingUnits,
  });
}
