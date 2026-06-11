import 'package:flutter/material.dart';
import 'package:trench_warfare/screens/tutorials/ui/controls/tutorial_ui_calculator.dart';

class TutorialAssistantGirl extends StatelessWidget {
  final Function onPress;

  const TutorialAssistantGirl({
    super.key,
    required this.onPress,
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
      child: GestureDetector(
        onTap: () {
          onPress();
        },
        child: Image(
          image: const AssetImage('assets/images/screens/tutorial/tutorial_girl.webp'),
          width: rect.width,
          height: rect.height,
        ),
      ),
    );
  }
}
