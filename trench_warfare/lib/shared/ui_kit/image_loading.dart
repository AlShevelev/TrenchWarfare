import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';

mixin ImageLoading {
  Future<ui.Image> loadImage(String imagePath, { Function completeCallback = _defaultCallback }) async {
    final data = await rootBundle.load(imagePath);
    final img = Uint8List.view(data.buffer);
    return _loadImage(img, completeCallback);
  }

  Future<ui.Image> _loadImage(Uint8List img, Function completeCallback) async {
    final completer = Completer<ui.Image>();
    ui.decodeImageFromList(img, (ui.Image img) {
      completeCallback();
      return completer.complete(img);
    });
    return completer.future;
  }

  static void _defaultCallback() {}
}