import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:trench_warfare/screens/save_load/save_load_library.dart';
import 'package:trench_warfare/shared/ui_kit/background.dart';

class SaveLoadScreen extends StatelessWidget {
  final bool _isSave;

  const SaveLoadScreen({super.key, required bool isSave}): _isSave = isSave;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.ltr,
      child: Background.path(
        imagePath: 'assets/images/screens/shared/screen_background.webp',
        child: SlotSelection(isSave: _isSave, onCancel: () {}, onSlotSelected: (slotId) {},),
      ),
    );
  }
}
