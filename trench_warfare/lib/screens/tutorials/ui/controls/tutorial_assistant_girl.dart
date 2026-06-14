import 'package:flutter/material.dart';

class TutorialAssistantGirl extends StatelessWidget {
  static const _sizeX = 112.0;
  static const _sizeY = 381.0;

  static const _offsetX = 5.0;

  final Function onPress;

  const TutorialAssistantGirl({
    super.key,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.sizeOf(context);

    return Positioned(
      left: screenSize.width - _sizeX - _offsetX,
      top: (screenSize.height - _sizeY) / 2,
      width: _sizeX,
      height: _sizeY,
      child: GestureDetector(
        onTap: () {
          onPress();
        },
        child: const Image(
          image: AssetImage('assets/images/screens/tutorial/tutorial_girl.webp'),
          width: _sizeX,
          height: _sizeY,
        ),
      ),
    );
  }
}
