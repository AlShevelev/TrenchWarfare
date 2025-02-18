import 'package:flutter/widgets.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/ai_progress/ai_turn_progress_painter.dart';

class AiTurnProgressWidget extends StatelessWidget {
  // [0; 1]
  final double _moneySpending;
  final double _carriers;
  final double _unitMovement;

  const AiTurnProgressWidget({
    super.key,
    required double moneySpending,
    required double carriers,
    required double unitMovement,
  })  : _moneySpending = moneySpending,
        _carriers = carriers,
        _unitMovement = unitMovement;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: CustomPaint(
        painter: AiTurnProgressPainter(
          moneySpending: _moneySpending,
          carriers: _carriers,
          unitMovement: _unitMovement,
        ),
        child: Container(
          alignment: AlignmentDirectional.center,
          height: 15,
        ),
      ),
    );
  }
}
