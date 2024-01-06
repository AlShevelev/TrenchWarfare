import 'dart:math' as math;

import 'package:trench_warfare/core_entities/entities/game_field.dart';
import 'package:trench_warfare/core_entities/entities/game_field_cell.dart';
import 'package:trench_warfare/screens/game_field_screen/model/algs/find_cells_around.dart';

/// Calculations for the G part of the F factor
class FindPathGFactorHeuristic {
  /// Default implementation
  double calculate(GameFieldCell priorCell, GameFieldCell nextCell) => 1.0;
}

/// Looks for a path from one cell to another
/// A* is used https://en.wikipedia.org/wiki/A*_search_algorithm
class FindPath {
  final List<GameFieldCell> _open = [];

  final Map<GameFieldCell, GameFieldCell> _cameFrom = <GameFieldCell, GameFieldCell>{};

  final Map<GameFieldCell, double> _gScore = <GameFieldCell, double>{};
  final Map<GameFieldCell, double> _fScore = <GameFieldCell, double>{};

  late final GameFieldReadOnly _gameField;

  late final FindPathGFactorHeuristic _findPathGFactorHeuristic;

  FindPath(GameFieldReadOnly gameField, FindPathGFactorHeuristic findPathGFactorHeuristic) {
    _gameField = gameField;
    _findPathGFactorHeuristic = findPathGFactorHeuristic;
  }

  Iterable<GameFieldCell> find(GameFieldCell startCell, GameFieldCell endCell) {
    _open.clear();
    _cameFrom.clear();
    _gScore.clear();
    _fScore.clear();

    _open.add(startCell);

    _gScore[startCell] = 0;
    _fScore[startCell] = _calculateHFactor(startCell, endCell);

    while (_open.isNotEmpty) {
      final currentIndex = _getOpenCellWithMinFIndex();
      final current =  _open[currentIndex];

      if (current == endCell) {
        return _reconstructPath(current);
      }

      _open.removeAt(currentIndex);

      final neighbors = FindCellsAround.find(_gameField, current);

      for (var neighbor in neighbors) {
        final tentativeGScore = _gScore[current]! + _findPathGFactorHeuristic.calculate(current, neighbor);

        if (tentativeGScore < (_gScore[neighbor] ?? double.maxFinite)) {
          _cameFrom[neighbor] = current;

          _gScore[neighbor] = tentativeGScore;
          _fScore[neighbor] = tentativeGScore + _calculateHFactor(neighbor, endCell);

          if (!_open.contains(neighbor)) {
            _open.add(neighbor);
          }
        }
      }
    }

    throw ArgumentError("An open set is empty but the end cell was never reached");
  }

  /// Calculates the H part of the F factor
  /// In our case it is a Euclidean distance between the cells
  double _calculateHFactor(GameFieldCell givenCell, GameFieldCell finalCell) =>
    math.sqrt(math.pow(givenCell.center.dx - finalCell.center.dx, 2) + math.pow(givenCell.center.dy - finalCell.center.dy, 2));

  int _getOpenCellWithMinFIndex() {
    var minF = double.maxFinite;
    var index = 0;

    for (var i = 0; i < _open.length; i++) {
      final f = _fScore[_open[i]]!;
      if (f < minF) {
        minF = f;
        index = i;
      }
    }

    return index;
  }

  Iterable<GameFieldCell> _reconstructPath(GameFieldCell end) {
    final totalPath = [end];

    var current = end;

    while (_cameFrom.containsKey(current)) {
      current = _cameFrom[current]!;
      totalPath.add(current);
    }

    return totalPath.reversed.toList();
  }
}