import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:trench_warfare/shared/ui_kit/image_loading.dart';

import 'background_painter.dart';

class Background extends StatefulWidget {
  final Widget child;
  late final String? _imagePath;
  late final ui.Image? _image;

  Background.path({required this.child, super.key, required String? imagePath}) {
    _imagePath = imagePath;
    _image = null;
  }

  Background.image({required this.child, super.key, required ui.Image? image}) {
    _image = image;
    _imagePath = null;
  }

  @override
  State<Background> createState() => _BackgroundState();
}

class _BackgroundState extends State<Background> with ImageLoading {
  late final ui.Image _background;
  bool _isBackgroundLoaded = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    if (widget._image != null) {
      _background = widget._image!;

      setState(() {
        _isBackgroundLoaded = true;
      });
    } else {
      _background = await loadImage(widget._imagePath!, completeCallback: () {
        setState(() {
          _isBackgroundLoaded = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if(_isBackgroundLoaded) {
      return CustomPaint(
        painter: BackgroundPainter(backgroundImage: _background),
        child: Container(
          constraints: const BoxConstraints.expand(),
          child: widget.child,
        ),
      );
    } else {
      return Container(
        constraints: const BoxConstraints.expand(),
        child: null,
      );
    }
  }
}