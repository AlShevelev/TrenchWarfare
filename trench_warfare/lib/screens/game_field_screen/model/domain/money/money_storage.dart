/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

import 'dart:math' as math;

import 'package:trench_warfare/core/entities/map_metadata/map_metadata_record.dart';
import 'package:trench_warfare/core/entities/game_field/game_field_library.dart';
import 'package:trench_warfare/core/entities/money/money_unit.dart';
import 'package:trench_warfare/core/enums/nation.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/money/calculators/money_calculators_library.dart';
import 'package:trench_warfare/shared/logger/logger_library.dart';

abstract interface class MoneyStorageRead {
  MoneyUnit get totalSum;

  MoneyUnit get totalIncome;

  MoneyUnit get totalExpenses;
}

class _IncomeAndExpenses {
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
  MoneyUnit get totalIncome => _totalIncome;

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

    Logger.info(
      'Created. nation: $_nation; totalSum: $_totalSum; income: $_totalIncome; expenses: $_totalExpenses',
      tag: 'MONEY_STORAGE',
    );
  }

  MoneyStorage.fromSaving(
    GameFieldRead gameField,
    Nation nation, {
    required int totalSumCurrency,
    required int totalSumIndustryPoints,
    required int totalIncomeCurrency,
    required int totalIncomeIndustryPoints,
    required int totalExpensesCurrency,
    required int totalExpensesIndustryPoints,
  })  : _gameField = gameField,
        _nation = nation,
        _totalSum = MoneyUnit(currency: totalSumCurrency, industryPoints: totalSumIndustryPoints),
        _totalIncome = MoneyUnit(currency: totalIncomeCurrency, industryPoints: totalIncomeIndustryPoints),
        _totalExpenses = MoneyUnit(
          currency: totalExpensesCurrency,
          industryPoints: totalExpensesIndustryPoints,
        );

  void recalculateIncomeAndSum() {
    _totalIncome = _calculateIncomeAndExpenses(income: true).income;
    _totalSum = _totalSum + _totalIncome;

    Logger.info(
      'Income and sum recalculated. nation: $_nation; totalSum: $_totalSum; income: $_totalIncome',
      tag: 'MONEY_STORAGE',
    );
  }

  void recalculateExpenses() {
    _totalExpenses = _calculateIncomeAndExpenses(expenses: true).expenses;
    Logger.info('Expenses recalculated. nation: $_nation; expenses: $_totalExpenses', tag: 'MONEY_STORAGE');
  }

  void recalculateIncomeAndExpenses() {
    final incomeAndExpenses = _calculateIncomeAndExpenses(income: true, expenses: true);
    _totalIncome = incomeAndExpenses.income;
    _totalExpenses = incomeAndExpenses.expenses;

    Logger.info(
      'Income and expenses recalculated. nation: $_nation; income: $_totalIncome; expenses: $_totalExpenses',
      tag: 'MONEY_STORAGE',
    );
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

    Logger.info(
      'Total sum reduced. nation: $_nation; totalSum: $_totalSum',
      tag: 'MONEY_STORAGE',
    );
  }

  void updateExpenses({required MoneyUnit oldValue, required MoneyUnit newValue}) {
    _totalExpenses -= oldValue;
    _totalExpenses += newValue;

    Logger.info(
      'Expenses updated. nation: $_nation; expenses: $_totalExpenses',
      tag: 'MONEY_STORAGE',
    );
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
