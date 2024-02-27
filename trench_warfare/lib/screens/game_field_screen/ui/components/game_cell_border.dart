part of game_field_components;

class GameCellBorder extends PositionComponent {
  // top-left
  late final Offset _position;

  late final GameFieldCellRead _cell;
  late final GameFieldRead _gameField;

  static final _borderAreaSize = ComponentConstants.cellRealSize * 0.96;
  static final _borderWidth =
      ((ComponentConstants.cellRealSize.x - _borderAreaSize.x) + (ComponentConstants.cellRealSize.y - _borderAreaSize.y)) / 2;

  // ignore: unnecessary_late
  static late final List<Offset> _vertices = _calculateVertices(_borderAreaSize);

  // ignore: unnecessary_late
  static late final Map<Nation, Paint> _paints = {};

  GameCellBorder(GameFieldCellRead cell, GameFieldRead gameField) {
    _cell = cell;
    _gameField = gameField;

    final positionCenter = Offset(cell.center.x, cell.center.y);
    _position = positionCenter - Offset(_borderAreaSize.x / 2, _borderAreaSize.y / 2);
  }

  @override
  void render(Canvas canvas) {
    if (_cell.nation == null) {
      return;
    }

    final allCellsAround = _gameField.findAllCellsAround(_cell);

    final paint = _getPaint(_cell.nation!);

    var index = -1;
    for (var cellAround in allCellsAround) {
      index++;
      if (cellAround == null || cellAround.nation == _cell.nation) {
        continue;
      }

      switch (index) {
        // top-right
        case 0:
          canvas.drawLine(_vertices[0] + _position, _vertices[1] + _position, paint);

        // right
        case 1:
          canvas.drawLine(_vertices[1] + _position, _vertices[2] + _position, paint);

        // bottom-right
        case 2:
          canvas.drawLine(_vertices[2] + _position, _vertices[3] + _position, paint);

        // bottom-left
        case 3:
          canvas.drawLine(_vertices[3] + _position, _vertices[4] + _position, paint);

        // left
        case 4:
          canvas.drawLine(_vertices[4] + _position, _vertices[5] + _position, paint);

        // top-left
        case 5:
          canvas.drawLine(_vertices[5] + _position, _vertices[0] + _position, paint);
      }
    }
  }

  /// From the top-central, clockwise
  static List<Offset> _calculateVertices(Vector2 size) {
    final a = size.x / 2;
    final b = a * math.tan(math.pi / 6);

    final result = [
      Offset(a, 0.0),
      Offset(size.x, b),
      Offset(size.x, size.y - b),
      Offset(a, size.y),
      Offset(0, size.y - b),
      Offset(0, b),
    ];

    return result;
  }

  static Paint _getPaint(Nation nation) {
    var paint = _paints[nation];

    if (paint == null) {
      paint = _createPaint(nation);
      _paints[nation] = paint;
    }

    return paint;
  }

  static Paint _createPaint(Nation nation) {
    final paint = switch (nation) {
      Nation.austriaHungary => BasicPalette.white.paint(),
      Nation.greece => BasicPalette.black.paint(),
      _ => throw UnimplementedError()
    };

    return paint
    ..strokeWidth = _borderWidth
    ..strokeCap = StrokeCap.round;
  }
}
