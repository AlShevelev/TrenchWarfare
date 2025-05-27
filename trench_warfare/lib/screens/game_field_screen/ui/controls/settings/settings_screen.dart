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
import 'package:trench_warfare/screens/settings/settings_library.dart';
import 'package:trench_warfare/shared/ui_kit/background.dart';

class SettingsScreen extends StatelessWidget {
  final GameFieldForControls _gameField;

  const SettingsScreen({
    super.key,
    required GameFieldForControls gameField,
  }) : _gameField = gameField;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Directionality(
        textDirection: ui.TextDirection.ltr,
        child: Background(
          imagePath: 'assets/images/screens/shared/screen_background.webp',
          child: Settings(
            onClose: (result) {
              _gameField.onSettingsClosed(result);
            },
          ),
        ),
      ),
    );
  }
}
