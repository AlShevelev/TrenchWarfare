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

class GameObjectDebug extends PositionComponent {
  final GameFieldCellRead _cell;

  GameObjectDebug({
    required GameFieldCellRead cell,
  }) : _cell = cell {
    priority = 1000;
  }

  @override
  void render(Canvas canvas) {
    _paintText(
      canvas,
      '${_cell.row};${_cell.col}\n${_cell.id}',
      fontSize: 12,
      color: AppColors.white,
      backgroundColor: AppColors.black,
    );
  }

  void _paintText(
    Canvas canvas,
    String text, {
    required double fontSize,
    required Color color,
    required Color backgroundColor,
  }) {
    final textStyle = TextStyle(
      color: color,
      backgroundColor: backgroundColor,
      fontWeight: FontWeight.w700,
      fontSize: fontSize,
    );

    final textSpan = TextSpan(
      text: text,
      style: textStyle,
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    final offset = Offset(
      _cell.center.x - textPainter.width / 2,
      _cell.center.y - textPainter.height / 2,
    );

    textPainter.paint(canvas, offset);
  }
}
