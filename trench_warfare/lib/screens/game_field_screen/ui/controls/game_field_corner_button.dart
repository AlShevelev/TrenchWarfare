import 'package:flutter/material.dart';

class GameFieldCornerButton extends StatelessWidget {
  static const _buttonSize = 40.0;

  final double? left;
  final double? top;
  final double? right;
  final double? bottom;

  final ImageProvider image;

  final Function onPress;

  const GameFieldCornerButton({
    super.key,
    this.left,
    this.top,
    this.right,
    this.bottom,
    required this.image,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      width: _buttonSize,
      height: _buttonSize,
      child: Material(
        child: InkWell(
          onTap: () { onPress(); }, // Handle your callback.
          splashColor: Colors.brown.withOpacity(0.5),
          child: Ink(
            height: _buttonSize,
            width: _buttonSize,
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(100),
              image: DecorationImage(
                image: image,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
