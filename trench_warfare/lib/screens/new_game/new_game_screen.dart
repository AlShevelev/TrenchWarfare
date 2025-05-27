/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

import 'package:flutter/widgets.dart';
import 'package:trench_warfare/screens/new_game/ui/map_selection/map_selection_library.dart';
import 'package:trench_warfare/shared/ui_kit/background.dart';

class NewGameScreen extends StatelessWidget {
  const NewGameScreen({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const Directionality(
      textDirection: TextDirection.ltr,
      child: Background(
        imagePath: 'assets/images/screens/shared/screen_background.webp',
        child: MapSelection(),
      ),
    );
  }
}
