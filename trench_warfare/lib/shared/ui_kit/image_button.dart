import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trench_warfare/app/theme/colors.dart';
import 'package:trench_warfare/audio/audio_library.dart';
import 'package:trench_warfare/shared/ui_kit/ui_constants.dart';

class ImageButton extends StatefulWidget {
  final String imageAsset;
  final double imageWidth;
  final double imageHeight;

  final Function onPress;

  final bool enabled;

  final _color = AppColors.black;

  const ImageButton({
    super.key,
    required this.imageAsset,
    this.enabled = true,
    required this.imageWidth,
    required this.imageHeight,
    required this.onPress,
  });

  @override
  State<StatefulWidget> createState() => _ImageButtonState();
}

class _ImageButtonState extends State<ImageButton> {
  var isPressed = false;

  @override
  Widget build(BuildContext context) {
    final audioController = context.read<AudioController>();

    return GestureDetector(
      onTap: () {
        if (!widget.enabled) {
          return;
        }

        audioController.playSound(SoundType.buttonClick);

        setState(() {
          isPressed = true;
        });

        Future.delayed(const Duration(milliseconds: UiConstants.pressButtonTime), () {
          widget.onPress();

          setState(() {
            isPressed = false;
          });
        });
      },

      child: Image.asset(
        width: 35,
        height: 35,
        widget.imageAsset,
        color: widget._color.withAlpha(isPressed ? 175 : 225),
      ),
    );
  }
}
