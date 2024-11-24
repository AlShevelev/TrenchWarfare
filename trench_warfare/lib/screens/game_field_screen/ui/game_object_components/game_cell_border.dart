part of game_field_components;

class GameCellBorder extends PositionComponent {
  // top-left
  late final Offset _position;

  late final Nation? _nation;
  late final List<GameFieldCell?> _allCellsAround;

  static final _borderAreaSize = ComponentConstants.cellRealSize;
  static final _borderWidth = (_borderAreaSize.x + _borderAreaSize.y) * 0.02;

  // ignore: unnecessary_late
  static late final List<Offset> _vertices = _calculateVertices(_borderAreaSize);

  // ignore: unnecessary_late
  static late final Map<Nation, List<Paint>> _paints = {};

  GameCellBorder(GameFieldCellRead cell, GameFieldRead gameField) {
    _nation = cell.nation;
    _allCellsAround = gameField.findAllCellsAround(cell).toList();

    const positionCenter = Offset(0, 0);
    _position = positionCenter - Offset(_borderAreaSize.x / 2, _borderAreaSize.y / 2);
  }

  static bool isNotEmpty(GameFieldCellRead cell, GameFieldRead gameField) =>
      gameField.findAllCellsAround(cell).any((c) => c != null && c.nation != cell.nation);

  @override
  void render(Canvas canvas) {
    final nation = _nation;

    if (nation == null) {
      return;
    }

    var index = -1;
    for (var cellAround in _allCellsAround) {
      index++;
      if (cellAround == null || cellAround.nation == nation) {
        continue;
      }

      switch (index) {
        // top-right
        case 0:
          _drawSide(canvas, nation, start: _vertices[0] + _position, end: _vertices[1] + _position);

        // right
        case 1:
          _drawSide(canvas, nation, start: _vertices[1] + _position, end: _vertices[2] + _position);

        // bottom-right
        case 2:
          _drawSide(canvas, nation, start: _vertices[2] + _position, end: _vertices[3] + _position);

        // bottom-left
        case 3:
          _drawSide(canvas, nation, start: _vertices[3] + _position, end: _vertices[4] + _position);

        // left
        case 4:
          _drawSide(canvas, nation, start: _vertices[4] + _position, end: _vertices[5] + _position);

        // top-left
        case 5:
          _drawSide(canvas, nation, start: _vertices[5] + _position, end: _vertices[0] + _position);
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

  void _drawSide(
    Canvas canvas,
    Nation nation, {
    required Offset start,
    required Offset end,
  }) =>
      _drawSideSegments(canvas, splitLine([0.25, 0.75], start: start, end: end), _getPaints(nation));

  void _drawSideSegments(Canvas canvas, List<Tuple2<Offset, Offset>> segments, List<Paint> paints) {
    canvas.drawLine(segments[0].item1, segments[0].item2, paints[0]);
    canvas.drawLine(segments[2].item1, segments[2].item2, paints[2]);
    canvas.drawLine(segments[1].item1, segments[1].item2, paints[1]);
  }

  static List<Paint> _getPaints(Nation nation) {
    var paint = _paints[nation];

    if (paint == null) {
      paint = _createPaints(nation);
      _paints[nation] = paint;
    }

    return paint;
  }

  static List<Paint> _createPaints(Nation nation) => [
        BasicPalette.black.paint()
          ..strokeWidth = _borderWidth
          ..strokeCap = StrokeCap.round,
        BasicPalette.white.paint()..strokeWidth = _borderWidth,
        BasicPalette.black.paint()
          ..strokeWidth = _borderWidth
          ..strokeCap = StrokeCap.round,
      ];
}
