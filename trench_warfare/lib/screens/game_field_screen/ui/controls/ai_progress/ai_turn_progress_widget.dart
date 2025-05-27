/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

import 'package:flutter/widgets.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/ai_progress/ai_turn_progress_painter.dart';

class AiTurnProgressWidget extends StatelessWidget {
  // [0; 1]
  final double _moneySpending;
  final double _unitMovement;

  const AiTurnProgressWidget({
    super.key,
    required double moneySpending,
    required double unitMovement,
  })  : _moneySpending = moneySpending,
        _unitMovement = unitMovement;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: CustomPaint(
        painter: AiTurnProgressPainter(
          moneySpending: _moneySpending,
          unitMovement: _unitMovement,
        ),
        child: Container(
          alignment: AlignmentDirectional.center,
          height: 10,
        ),
      ),
    );
  }
}
