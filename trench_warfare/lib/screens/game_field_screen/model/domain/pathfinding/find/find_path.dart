part of pathfinding;

/// Calculations for the G part of the F factor
abstract class FindPathSettings {
  /// Null value means the [nextCell] is unreachable
  double? calculateGFactorHeuristic(GameFieldCell priorCell, GameFieldCell nextCell);

  bool isCellReachable(GameFieldCell cell);
}

/// Looks for a path from one cell to another
/// A* is used https://en.wikipedia.org/wiki/A*_search_algorithm
class FindPath {
  final List<GameFieldCell> _open = [];

  final Map<GameFieldCell, GameFieldCell> _cameFrom = <GameFieldCell, GameFieldCell>{};

  final Map<GameFieldCell, double> _gScore = <GameFieldCell, double>{};
  final Map<GameFieldCell, double> _fScore = <GameFieldCell, double>{};

  late final GameFieldRead _gameField;

  late final FindPathSettings _settings;

  FindPath(GameFieldRead gameField, FindPathSettings findPathGFactorHeuristic) {
    _gameField = gameField;
    _settings = findPathGFactorHeuristic;
  }

  Iterable<GameFieldCell> find(GameFieldCell startCell, GameFieldCell endCell) {
    _open.clear();
    _cameFrom.clear();
    _gScore.clear();
    _fScore.clear();

    if (startCell == endCell || !_settings.isCellReachable(endCell)) {
      return List<GameFieldCell>.empty();
    }

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

      final neighbors = _gameField.findCellsAround(current);

      for (var neighbor in neighbors) {
        final nextGScope = _settings.calculateGFactorHeuristic(current, neighbor);

        // An unreachable cell must be skipped
        if (nextGScope == null) {
          continue;
        }

        final tentativeGScore = _gScore[current]! + nextGScope;

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

    // Can't construct a path - for example, when a reachable cell (the final one) is surrounded by unreachable cells
    return List<GameFieldCell>.empty();
  }

  /// Calculates the H part of the F factor
  /// In our case it is a Euclidean distance between the cells
  double _calculateHFactor(GameFieldCell givenCell, GameFieldCell finalCell) =>
    _gameField.calculateDistance(givenCell, finalCell);

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