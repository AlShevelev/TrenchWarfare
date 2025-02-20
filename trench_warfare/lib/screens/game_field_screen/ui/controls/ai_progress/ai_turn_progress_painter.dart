import 'package:flutter/widgets.dart';
import 'package:trench_warfare/app/theme/colors.dart';

class AiTurnProgressPainter extends CustomPainter {
  // [0; 1]
  final double _moneySpending;
  final double _unitMovement;

  const AiTurnProgressPainter({
    required double moneySpending,
    required double unitMovement,
  })  : _moneySpending = moneySpending,
        _unitMovement = unitMovement;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.yellow
      ..strokeWidth = _getStrokeWidth(size.height);

    if (_moneySpending != 0) {
      _drawLine(canvas, paint, size, _moneySpending, lineNumber: 0);
    }

    if (_unitMovement != 0) {
      _drawLine(canvas, paint, size, _unitMovement, lineNumber: 1);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  double _getStrokeWidth(double height) => height / 2.0;

  /// [lineNumber] is in [0; 1]
  Offset _getStartOffset({required Size size, required int lineNumber}) {
    return Offset(lineNumber == 0 ? 0 : size.width / 2, size.height / 2.0);
  }

  Offset _getEndOffset({
    required double width,
    required double value,
    required Offset startOffset,
  }) =>
      Offset(startOffset.dx + (width / 2.0) * value, startOffset.dy);

  void _drawLine(Canvas canvas, Paint paint, Size size, double value, {required int lineNumber}) {
    final start = _getStartOffset(size: size, lineNumber: lineNumber);
    final end = _getEndOffset(width: size.width, value: value, startOffset: start);
    canvas.drawLine(start, end, paint);
  }
}
