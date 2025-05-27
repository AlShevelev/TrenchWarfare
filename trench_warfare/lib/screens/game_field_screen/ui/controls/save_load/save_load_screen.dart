/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/game_field.dart';
import 'package:trench_warfare/screens/save_load/save_load_library.dart';
import 'package:trench_warfare/shared/ui_kit/background.dart';

class SaveLoadScreen extends StatelessWidget {
  final bool _isSave;

  final GameFieldForControls _gameField;

  const SaveLoadScreen({super.key, required bool isSave, required GameFieldForControls gameField,})
      : _isSave = isSave,
        _gameField = gameField;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.ltr,
      child: Background(
        imagePath: 'assets/images/screens/shared/screen_background.webp',
        child: SlotSelection(
          isSave: _isSave,
          onCancel: () {
            _gameField.onCancelled();
          },
          onSlotSelected: (slot, mapFileName) {
            _gameField.onSaveSlotSelected(slot);
          },
        ),
      ),
    );
  }
}
