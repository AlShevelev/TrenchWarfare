import 'package:flutter/widgets.dart';
import 'package:trench_warfare/app/theme/colors.dart';

class AiTurnProgressPainter extends CustomPainter {
  // [0; 1]
  final double _moneySpending;
  final double _carriers;
  final double _unitMovement;

  const AiTurnProgressPainter({
    required double moneySpending,
    required double carriers,
    required double unitMovement,
  })  : _moneySpending = moneySpending,
        _carriers = carriers,
        _unitMovement = unitMovement;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.yellow
      ..strokeWidth = _getStrokeWidth(size.height);

    final valuesToPaint = [];
    if (_moneySpending > 0) {
      valuesToPaint.add(_moneySpending);
    }

    if (_carriers > 0) {
      valuesToPaint.add(_carriers);
    }

    if (_unitMovement > 0) {
      valuesToPaint.add(_unitMovement);
    }

    for (var i = 0; i < valuesToPaint.length; i++) {
      final start = _getStartOffset(height: size.height, lineNumber: i);
      final end = _getEndOffset(width: size.width, value: valuesToPaint[i], startOffset: start);
      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  double _getStrokeWidth(double height) => height / 5.0;

  /// [lineNumber] is in [0; 2]
  Offset _getStartOffset({required double height, required int lineNumber}) {
    final strokeWidth = _getStrokeWidth(height);

    final y = switch (lineNumber) {
      0 => strokeWidth / 2.0,
      1 => height / 2.0,
      2 => height - strokeWidth / 2.0,
      _ => throw UnsupportedError('This value is not supported: $lineNumber')
    };

    return Offset(0, y);
  }

  Offset _getEndOffset({
    required double width,
    required double value,
    required Offset startOffset,
  }) =>
      Offset(width * value, startOffset.dy);
}
