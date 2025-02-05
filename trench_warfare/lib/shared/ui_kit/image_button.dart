import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trench_warfare/app/theme/colors.dart';
import 'package:trench_warfare/audio/audio_library.dart';
import 'package:trench_warfare/shared/ui_kit/ui_constants.dart';

class ImageButton extends StatefulWidget {
  final ImageProvider _image;
  final double _imageWidth;
  final double _imageHeight;

  final Function _onPress;

  final bool _enabled;

  final Color? _color;

  final Color? _pressedColor;

  const ImageButton({
    super.key,
    required ImageProvider image,
    bool enabled = true,
    required double imageWidth,
    required double imageHeight,
    Color? color,
    Color? pressedColor,
    required Function onPress,
  })  : _image = image,
        _enabled = enabled,
        _imageWidth = imageWidth,
        _imageHeight = imageHeight,
        _color = color,
        _pressedColor = pressedColor,
        _onPress = onPress;

  ImageButton.forImages({
    super.key,
    required ImageProvider image,
    bool enabled = true,
    required double imageWidth,
    required double imageHeight,
    required Function onPress,
  })  : _image = image,
        _enabled = enabled,
        _imageWidth = imageWidth,
        _imageHeight = imageHeight,
        _color = null,
        _pressedColor = AppColors.black.withAlpha(75),
        _onPress = onPress;

  ImageButton.forBlackIcons({
    super.key,
    required ImageProvider image,
    bool enabled = true,
    required double imageWidth,
    required double imageHeight,
    required Function onPress,
  })  : _image = image,
        _enabled = enabled,
        _imageWidth = imageWidth,
        _imageHeight = imageHeight,
        _color = AppColors.black,
        _pressedColor = AppColors.white.withAlpha(75),
        _onPress = onPress;

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
        if (!widget._enabled) {
          return;
        }

        audioController.playSound(SoundType.buttonClick);

        setState(() {
          isPressed = true;
        });

        Future.delayed(const Duration(milliseconds: UiConstants.pressButtonTime), () {
          widget._onPress();

          setState(() {
            isPressed = false;
          });
        });
      },
      child: Image(
        image: widget._image,
        width: widget._imageWidth,
        height: widget._imageHeight,
        color: isPressed ? widget._pressedColor : widget._color,
        colorBlendMode: BlendMode.srcATop,
      ),
    );
  }
}
