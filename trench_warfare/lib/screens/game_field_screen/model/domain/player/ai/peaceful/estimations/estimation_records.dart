part of estimations;

class ProductionCenterEstimationRecord
    extends EstimationRecord<ProductionCenterType, ProductionCenterInGeneralEstimationResult> {
  ProductionCenterEstimationRecord({required super.type, required super.result});
}

class TerrainModifierEstimationRecord
    extends EstimationRecord<TerrainModifierType, MineFieldsInGeneralEstimationResult> {
  TerrainModifierEstimationRecord({required super.type, required super.result});
}

class UnitsEstimationRecord
    extends EstimationRecord<UnitType, UnitsInGeneralEstimationResult> {
  UnitsEstimationRecord({required super.type, required super.result});
}
