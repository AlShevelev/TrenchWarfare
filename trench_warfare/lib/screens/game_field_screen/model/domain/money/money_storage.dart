import 'package:trench_warfare/screens/game_field_screen/model/domain/game_field/game_field_library.dart';
import 'package:trench_warfare/core_entities/entities/money/money_unit.dart';
import 'package:trench_warfare/core_entities/enums/nation.dart';
import 'package:trench_warfare/screens/game_field_screen/model/data/readers/metadata/dto/map_metadata.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/money/calculators/money_calculators_library.dart';

abstract interface class MoneyStorageRead {
  MoneyUnit get actual;
}

class MoneyStorage implements MoneyStorageRead {
  late MoneyUnit _actual;
  @override
  MoneyUnit get actual => _actual;

  late final GameFieldRead _gameField;

  late final Nation _nation;

  MoneyStorage(this._gameField, NationRecord nation) {
    _nation = nation.code;
    _actual = MoneyUnit(currency: nation.startMoney, industryPoints: nation.startIndustryPoints);
  }

  void recalculate() {
    _actual = _actual + _gameField.cells
        .where((c) => c.nation == _nation)
        .map((c) => MoneyCellCalculator.calculateCellIncome(c))
        .reduce((c1, c2) => c1 + c2);
  }

  void withdraw(MoneyUnit toWithdraw) => _actual = _actual - toWithdraw;
}
