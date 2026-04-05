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
  final GameFieldRead _gameField;

  GameObjectDebug(GameFieldRead gameField) : _gameField = gameField {
    priority = 1000;
  }

  @override
  void render(Canvas canvas) {
    final textStyle = TextStyle(
      color: AppColors.white.withOpacity(0.5),
      backgroundColor: AppColors.black.withOpacity(0.5),
      fontWeight: FontWeight.w700,
      fontSize: 12,
    );

    for (final cell in _gameField.cells) {
      _paintText(canvas, cell, textStyle);
    }
  }

  void _paintText(Canvas canvas, GameFieldCellRead cell, TextStyle textStyle) {
    final textSpan = TextSpan(
      text: '${cell.row};${cell.col};${cell.id}',
      style: textStyle,
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    final offset = Offset(
      cell.center.x - textPainter.width / 2,
      cell.center.y - textPainter.height / 2,
    );

    textPainter.paint(canvas, offset);
  }
}
