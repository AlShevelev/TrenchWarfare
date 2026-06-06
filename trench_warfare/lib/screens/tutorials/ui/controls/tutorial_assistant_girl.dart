import 'package:flutter/material.dart';

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
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    final left = screenWidth - offsetX - sizeX;
    final top = screenHeight - offsetY - sizeY;

    return Positioned(
      left: left,
      top: top,
      width: sizeX,
      height: sizeY,
      child: const Image(
        image: AssetImage('assets/images/screens/tutorial/tutorial_girl.webp'),
        width: sizeX,
        height: sizeY,
      ),
    );
  }
}
