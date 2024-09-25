import 'dart:math' as math;

import 'package:trench_warfare/screens/game_field_screen/model/domain/game_field/game_field_library.dart';
import 'package:trench_warfare/core_entities/entities/money/money_unit.dart';
import 'package:trench_warfare/core_entities/enums/nation.dart';
import 'package:trench_warfare/screens/game_field_screen/model/data/readers/metadata/dto/map_metadata.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/money/calculators/money_calculators_library.dart';

abstract interface class MoneyStorageRead {
  MoneyUnit get totalSum;

  MoneyUnit get totalIncome;

  MoneyUnit get totalExpenses;
}

class _IncomeAndExpenses{
  final MoneyUnit income;
  final MoneyUnit expenses;

  _IncomeAndExpenses({required this.income, required this.expenses});
}

class MoneyStorage implements MoneyStorageRead {
  MoneyUnit _totalSum;
  @override
  MoneyUnit get totalSum => _totalSum;

  late MoneyUnit _totalIncome;
  @override
  MoneyUnit get totalIncome => throw _totalIncome;

  late MoneyUnit _totalExpenses;
  @override
  MoneyUnit get totalExpenses => _totalExpenses;

  late final GameFieldRead _gameField;

  late final Nation _nation;

  MoneyStorage(GameFieldRead gameField, NationRecord nation)
      : _gameField = gameField,
        _nation = nation.code,
        _totalSum = MoneyUnit(currency: nation.startMoney, industryPoints: nation.startIndustryPoints) {
    recalculateIncomeAndExpenses();
  }

  void recalculateIncomeAndSum() {
    _totalIncome = _calculateIncomeAndExpenses(income: true).income;
    _totalSum = _totalSum + _totalIncome;
  }

  void recalculateExpenses() {
    _totalExpenses = _calculateIncomeAndExpenses(expenses: true).expenses;
  }

  void recalculateIncomeAndExpenses() {
    final incomeAndExpenses = _calculateIncomeAndExpenses(income: true, expenses: true);
    _totalIncome = incomeAndExpenses.income;
    _totalExpenses = incomeAndExpenses.expenses;
  }

  void reduceTotalSum(MoneyUnit toReduce) {
    var newSum = _totalSum - toReduce;

    if (newSum.currency < 0 || newSum.industryPoints < 0) {
      _totalSum = newSum.copy(
        currency: math.max(0, newSum.currency),
        industryPoints: math.max(0, newSum.industryPoints),
      );
    } else {
      _totalSum = newSum;
    }
  }

  void updateExpenses({required MoneyUnit oldValue, required MoneyUnit newValue}) {
    _totalExpenses -= oldValue;
    _totalExpenses += newValue;
  }

  _IncomeAndExpenses _calculateIncomeAndExpenses({bool income = false, bool expenses = false}) {
    var incomeSum = MoneyUnit.zero;
    var expensesSum = MoneyUnit.zero;

    if (income || expenses) {
      for (var cell in _gameField.cells) {
        if (cell.nation != _nation) {
          continue;
        }

        if (income) {
          incomeSum += MoneyCellCalculator.calculateCellIncome(cell);
        }

        if (expenses && cell.units.isNotEmpty) {
          for (final unit in cell.units) {
            expensesSum += MoneyUnitsCalculator.calculateExpense(unit);
          }
        }
      }
    }

    return _IncomeAndExpenses(income: incomeSum, expenses: expensesSum);
  }
}
