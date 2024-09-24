import 'package:flutter/cupertino.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/game_field/game_field_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/money/money_storage.dart';

abstract interface class EstimationData {
  GameFieldCellRead get cell;
}

class EstimationResult<D extends EstimationData> {
  final double weight;

  final D data;

  EstimationResult({required this.weight, required this.data});
}

abstract class Estimator<D extends EstimationData> {
  Iterable<EstimationResult<D>> estimate();

  @protected
  double getMoneyWeightFactor(MoneyStorageRead money) {
    if (money.totalExpenses.currency == 0 || money.totalExpenses.industryPoints == 0) {
      return 1.0;
    }

    final factor1 = money.totalIncome.currency.toDouble() / money.totalExpenses.currency;
    final factor2 = money.totalIncome.industryPoints.toDouble() / money.totalExpenses.industryPoints;

    final factor3 = money.totalSum.currency.toDouble() / (2.0 * money.totalExpenses.currency);
    final factor4 = money.totalSum.industryPoints.toDouble() / (2.0 * money.totalExpenses.industryPoints);

    return (factor1 + factor2 + factor3 + factor4) / 4.0;
  }
}
