import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/game_field.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/controls/game_field_controls.dart';
import 'package:trench_warfare/shared/ui_kit/background.dart';

class GameFieldScreen extends StatelessWidget {
  late final String _mapName;

  GameFieldScreen({required mapName, Key? key}) : super(key: key) {
    _mapName = mapName;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Background(
        imagePath: 'assets/images/background.webp',
        child: GameWidget(
          game: GameField(mapName: _mapName),
          overlayBuilderMap: {
            GameFieldControls.overlayKey: (BuildContext context, GameField gameField) {
              return GameFieldControls(gameField);
            },
          },
        ),
      ),
    );
  }
}
