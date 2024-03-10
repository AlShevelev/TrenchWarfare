import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'background_painter.dart';

class Background extends StatefulWidget {
  final Widget child;
  final String imagePath;

  const Background({required this.child, super.key, required this.imagePath});

  @override
  State<Background> createState() => _BackgroundState();
}

class _BackgroundState extends State<Background> {
  late final ui.Image _background;
  bool _isBackgroundLoaded = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    final data = await rootBundle.load(widget.imagePath);
    _background = await loadImage(Uint8List.view(data.buffer));
  }

  Future<ui.Image> loadImage(Uint8List img) async {
    final completer = Completer<ui.Image>();
    ui.decodeImageFromList(img, (ui.Image img) {
      setState(() {
        _isBackgroundLoaded = true;
      });
      return completer.complete(img);
    });
    return completer.future;
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