import 'package:flutter/material.dart';
import 'package:trench_warfare/screens/tutorials/ui/controls/tutorial_ui_calculator.dart';

class TutorialAssistantGirl extends StatelessWidget {
  static const sizeX = 112.0;
  static const sizeY = 381.0;

  static const offsetX = 5.0;
  static const offsetY = 140.0;

  const TutorialAssistantGirl({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.sizeOf(context);

    final rect = TutorialUiCalculator.getAssistantRect(screenSize);

    return Positioned(
      left: rect.left,
      top: rect.top,
      width: rect.width,
      height: rect.height,
      child: const Image(
        image: AssetImage('assets/images/screens/tutorial/tutorial_girl.webp'),
        width: sizeX,
        height: sizeY,
      ),
    );
  }
}
