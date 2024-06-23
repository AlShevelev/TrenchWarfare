part of peaceful_player_ai;

class ProductionCenterEstimationRecord
    extends EstimationRecord<ProductionCenterType, ProductionCenterEstimationResult> {
  ProductionCenterEstimationRecord({required super.type, required super.result});
}

class TerrainModifierEstimationRecord
    extends EstimationRecord<TerrainModifierType, MineFieldsEstimationResult> {
  TerrainModifierEstimationRecord({required super.type, required super.result});
}

class UnitsEstimationRecord
    extends EstimationRecord<UnitType, UnitsEstimationResult> {
  UnitsEstimationRecord({required super.type, required super.result});
}
