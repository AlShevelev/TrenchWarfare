import 'package:flutter/widgets.dart';
import 'package:trench_warfare/screens/new_game/ui/map_selection.dart';
import 'package:trench_warfare/shared/ui_kit/background.dart';

class NewGameScreen extends StatelessWidget {
  const NewGameScreen({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Background.path(
        imagePath: 'assets/images/screens/shared/screen_background.webp',
        child: const MapSelection(),
      ),
    );
  }
}
