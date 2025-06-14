/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of game_field_components;

class GameCellBorder extends PositionComponent {
  // top-left
  late final Offset _position;

  late final Nation _nation;
  late final List<bool> _sidesToDraw;

  static final _borderAreaSize = ComponentConstants.cellRealSize * 0.96;
  static final _borderWidth =
      ((ComponentConstants.cellRealSize.x - _borderAreaSize.x) + (ComponentConstants.cellRealSize.y - _borderAreaSize.y)) / 2;

  // ignore: unnecessary_late
  static late final List<Offset> _vertices = InGameMath.getHexVertices(_borderAreaSize);

  // ignore: unnecessary_late
  static late final Map<Nation, List<Paint>> _paints = {};

  GameCellBorder(GameFieldCellRead cell, GameFieldRead gameField) {
    _nation = cell.nation!;

    _sidesToDraw = [true, true, true, true, true, true];
    final allCellsAround = gameField.findAllCellsAround(cell);
    for (var i = 0; i < allCellsAround.length; i++) {
      final cellAround = allCellsAround.elementAt(i);
      _sidesToDraw[i] = !(cellAround == null || cellAround.nation == cell.nation);
    }

    _position = -Offset(_borderAreaSize.x / 2, _borderAreaSize.y / 2);
  }

  static bool needToDrawBorders(GameFieldCellRead cell, GameFieldRead gameField) {
    if (cell.nation == null) {
      return false;
    }

    final allCellsAround = gameField.findCellsAround(cell);
    return allCellsAround.any((c) => c.nation != cell.nation);
  }

  @override
  void render(Canvas canvas) {
    for (var i = 0; i < _sidesToDraw.length; i++) {
      if (!_sidesToDraw[i]) {
        continue;
      }

      switch (i) {
        // top-right
        case 0:
          _drawSide(canvas, _nation, start: _vertices[0] + _position, end: _vertices[1] + _position);

        // bottom-right
        case 1:
          _drawSide(canvas, _nation, start: _vertices[1] + _position, end: _vertices[2] + _position);

        // bottom
        case 2:
          _drawSide(canvas, _nation, start: _vertices[2] + _position, end: _vertices[3] + _position);

        // bottom-left
        case 3:
          _drawSide(canvas, _nation, start: _vertices[3] + _position, end: _vertices[4] + _position);

        // top-left
        case 4:
          _drawSide(canvas, _nation, start: _vertices[4] + _position, end: _vertices[5] + _position);

        // top
        case 5:
          _drawSide(canvas, _nation, start: _vertices[5] + _position, end: _vertices[0] + _position);
      }
    }
  }

  void _drawSide(
    Canvas canvas,
    Nation nation, {
    required Offset start,
    required Offset end,
  }) {
    switch (nation) {
      case Nation.austriaHungary:
      case Nation.greece:
      case Nation.japan:
      case Nation.mongolia:
      case Nation.turkey:
        _drawSideSegments(canvas, InGameMath.splitLine([0.25, 0.75], start: start, end: end), _getPaints(nation));
      case Nation.belgium:
      case Nation.bulgaria:
      case Nation.china:
      case Nation.france:
      case Nation.germany:
      case Nation.greatBritain:
      case Nation.italy:
      case Nation.korea:
      case Nation.mexico:
      case Nation.montenegro:
      case Nation.romania:
      case Nation.russia:
      case Nation.serbia:
      case Nation.usNorth:
      case Nation.usSouth:
      case Nation.usa:
        _drawSideSegments(canvas, InGameMath.splitLine([1.0/3, 2.0/3], start: start, end: end), _getPaints(nation));
      default:
        throw UnimplementedError();
    }
  }

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

  static List<Paint> _createPaints(Nation nation) {
    return switch (nation) {
      Nation.austriaHungary => [
          BasicPalette.black.paint()
            ..strokeWidth = _borderWidth
            ..strokeCap = StrokeCap.round,
          Paint()
            ..color = const Color(0xFFFFDD10)
            ..strokeWidth = _borderWidth,
          BasicPalette.black.paint()
            ..strokeWidth = _borderWidth
            ..strokeCap = StrokeCap.round,
        ],
      Nation.belgium => [
          BasicPalette.black.paint()
            ..strokeWidth = _borderWidth
            ..strokeCap = StrokeCap.round,
          Paint()
            ..color = const Color(0xFFFEDB24)
            ..strokeWidth = _borderWidth,
          Paint()
            ..color = const Color(0xFFef343f)
            ..strokeWidth = _borderWidth
            ..strokeCap = StrokeCap.round,
        ],
      Nation.bulgaria => [
        BasicPalette.white.paint()
          ..strokeWidth = _borderWidth
          ..strokeCap = StrokeCap.round,
        Paint()
          ..color = const Color(0xFF00966E)
          ..strokeWidth = _borderWidth,
        Paint()
          ..color = const Color(0XFFD62612)
          ..strokeWidth = _borderWidth
          ..strokeCap = StrokeCap.round,
      ],
      Nation.china => [
        Paint()
          ..color = const Color(0XFFD70016)
          ..strokeWidth = _borderWidth
          ..strokeCap = StrokeCap.round,
        Paint()
          ..color = const Color(0XFFFFC502)
          ..strokeWidth = _borderWidth,
        Paint()
          ..color = const Color(0XFF09639B)
          ..strokeWidth = _borderWidth
          ..strokeCap = StrokeCap.round,
      ],
      Nation.france => [
        Paint()
          ..color = const Color(0XFF002654)
          ..strokeWidth = _borderWidth
          ..strokeCap = StrokeCap.round,
        BasicPalette.white.paint()..strokeWidth = _borderWidth,
        Paint()
          ..color = const Color(0XFFCB0018)
          ..strokeWidth = _borderWidth
          ..strokeCap = StrokeCap.round,
      ],
      Nation.germany => [
        BasicPalette.black.paint()
          ..strokeCap = StrokeCap.round
          ..strokeWidth = _borderWidth,
        BasicPalette.white.paint()..strokeWidth = _borderWidth,
        Paint()
          ..color = const Color(0XFFDD0000)
          ..strokeWidth = _borderWidth
          ..strokeCap = StrokeCap.round,
      ],
      Nation.greatBritain => [
        Paint()
          ..color = const Color(0XFFC8102D)
          ..strokeCap = StrokeCap.round
          ..strokeWidth = _borderWidth,
        Paint()
          ..color = const Color(0XFF000657)
          ..strokeWidth = _borderWidth,
        BasicPalette.white.paint()
          ..strokeWidth = _borderWidth
          ..strokeCap = StrokeCap.round,
      ],
      Nation.greece => [
          Paint()
            ..color = const Color(0XFF0E5DAF)
            ..strokeWidth = _borderWidth
            ..strokeCap = StrokeCap.round,
          BasicPalette.white.paint()..strokeWidth = _borderWidth,
          Paint()
            ..color = const Color(0XFF0E5DAF)
            ..strokeWidth = _borderWidth
            ..strokeCap = StrokeCap.round,
        ],
      Nation.italy => [
        Paint()
          ..color = const Color(0XFF008732)
          ..strokeWidth = _borderWidth
          ..strokeCap = StrokeCap.round,
        BasicPalette.white.paint()..strokeWidth = _borderWidth,
        Paint()
          ..color = const Color(0XFFCA1829)
          ..strokeWidth = _borderWidth
          ..strokeCap = StrokeCap.round,
      ],
      Nation.japan => [
        BasicPalette.white.paint()
          ..strokeWidth = _borderWidth
          ..strokeCap = StrokeCap.round,
        Paint()
          ..color = const Color(0XFFCA1829)
          ..strokeWidth = _borderWidth,
        BasicPalette.white.paint()
          ..strokeWidth = _borderWidth
          ..strokeCap = StrokeCap.round,
      ],
      Nation.korea => [
        BasicPalette.white.paint()
          ..strokeWidth = _borderWidth
          ..strokeCap = StrokeCap.round,
        Paint()
          ..color = const Color(0XFF26176F)
          ..strokeWidth = _borderWidth,
        Paint()
          ..color = const Color(0XFFD9231D)
          ..strokeWidth = _borderWidth
          ..strokeCap = StrokeCap.round,
      ],
      Nation.mexico => [
        Paint()
          ..color = const Color(0XFF008732)
          ..strokeWidth = _borderWidth
          ..strokeCap = StrokeCap.round,
        BasicPalette.white.paint()..strokeWidth = _borderWidth,
        Paint()
          ..color = const Color(0XFFCA1829)
          ..strokeWidth = _borderWidth
          ..strokeCap = StrokeCap.round,
      ],
      Nation.mongolia => [
        Paint()
          ..color = const Color(0XFFDB171C)
          ..strokeWidth = _borderWidth
          ..strokeCap = StrokeCap.round,
        Paint()
          ..color = const Color(0XFF19A6E0)
          ..strokeWidth = _borderWidth,
        Paint()
          ..color = const Color(0XFFDB171C)
          ..strokeWidth = _borderWidth
          ..strokeCap = StrokeCap.round,
      ],
      Nation.montenegro => [
        Paint()
          ..color = const Color(0XFFC40307)
          ..strokeWidth = _borderWidth
          ..strokeCap = StrokeCap.round,
        Paint()
          ..color = const Color(0XFF1D5D91)
          ..strokeWidth = _borderWidth,
        BasicPalette.white.paint()
          ..strokeWidth = _borderWidth
          ..strokeCap = StrokeCap.round,
      ],
      Nation.romania => [
        Paint()
          ..color = const Color(0XFF002b7f)
          ..strokeWidth = _borderWidth
          ..strokeCap = StrokeCap.round,
        Paint()
          ..color = const Color(0XFFFCD017)
          ..strokeWidth = _borderWidth,
        Paint()
          ..color = const Color(0XFFCE1226)
          ..strokeWidth = _borderWidth
          ..strokeCap = StrokeCap.round,
      ],
      Nation.russia => [
        BasicPalette.white.paint()
          ..strokeWidth = _borderWidth
          ..strokeCap = StrokeCap.round,
        Paint()
          ..color = const Color(0XFF0039A6)
          ..strokeWidth = _borderWidth,
        Paint()
          ..color = const Color(0XFFD52B1D)
          ..strokeWidth = _borderWidth
          ..strokeCap = StrokeCap.round,
      ],
      Nation.serbia => [
        Paint()
          ..color = const Color(0XFFC6363D)
          ..strokeWidth = _borderWidth
          ..strokeCap = StrokeCap.round,
        Paint()
          ..color = const Color(0XFF0D4076)
          ..strokeWidth = _borderWidth,
        BasicPalette.white.paint()
          ..strokeWidth = _borderWidth
          ..strokeCap = StrokeCap.round,
      ],
      Nation.turkey => [
        Paint()
          ..color = const Color(0XFFE30A17)
          ..strokeWidth = _borderWidth
          ..strokeCap = StrokeCap.round,
        BasicPalette.white.paint()..strokeWidth = _borderWidth,
        Paint()
          ..color = const Color(0XFFE30A17)
          ..strokeWidth = _borderWidth
          ..strokeCap = StrokeCap.round,
      ],
      Nation.usNorth => [
        BasicPalette.white.paint()
          ..strokeWidth = _borderWidth
          ..strokeCap = StrokeCap.round,
        Paint()
          ..color = const Color(0XFF00084E)
          ..strokeWidth = _borderWidth,
        Paint()
          ..color = const Color(0XFFAF0022)
          ..strokeWidth = _borderWidth
          ..strokeCap = StrokeCap.round,
      ],
      Nation.usSouth => [
        Paint()
          ..color = const Color(0XFFbf0a30)
          ..strokeWidth = _borderWidth
          ..strokeCap = StrokeCap.round,
        BasicPalette.white.paint()..strokeWidth = _borderWidth,
        Paint()
          ..color = const Color(0XFF002868)
          ..strokeWidth = _borderWidth
          ..strokeCap = StrokeCap.round,
      ],
      Nation.usa => [
        BasicPalette.white.paint()
          ..strokeWidth = _borderWidth
          ..strokeCap = StrokeCap.round,
        Paint()
          ..color = const Color(0XFF00084E)
          ..strokeWidth = _borderWidth,
        Paint()
          ..color = const Color(0XFFAF0022)
          ..strokeWidth = _borderWidth
          ..strokeCap = StrokeCap.round,
      ],
    };
  }
}
