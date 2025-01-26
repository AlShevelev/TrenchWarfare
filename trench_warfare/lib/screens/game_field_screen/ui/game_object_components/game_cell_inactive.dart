part of game_field_components;

class GameCellInactive extends PositionComponent {
  // top-left
  late final Offset _position;

  static final _borderAreaSize = ComponentConstants.cellRealSize;

  // ignore: unnecessary_late
  static late final List<Offset> _vertices = InGameMath.getHexVertices(_borderAreaSize);

  GameCellInactive(GameFieldCellRead cell) {
    final positionCenter = Offset(cell.center.x, cell.center.y);
    _position = positionCenter - Offset(_borderAreaSize.x / 2, _borderAreaSize.y / 2);
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = const Color(0x90000000)
      ..style = PaintingStyle.fill;

    final v0 = _vertices[0] + _position;
    final v1 = _vertices[1] + _position;
    final v2 = _vertices[2] + _position;
    final v3 = _vertices[3] + _position;
    final v4 = _vertices[4] + _position;
    final v5 = _vertices[5] + _position;

    final path = Path()
      ..moveTo(v0.dx, v0.dy)
      ..lineTo(v1.dx, v1.dy)
      ..lineTo(v2.dx, v2.dy)
      ..lineTo(v3.dx, v3.dy)
      ..lineTo(v4.dx, v4.dy)
      ..lineTo(v5.dx, v5.dy)
      ..lineTo(v0.dx, v0.dy);

    canvas.drawPath(path, paint);
  }
}
