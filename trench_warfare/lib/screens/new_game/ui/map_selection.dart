import 'package:flutter/cupertino.dart';
import 'package:trench_warfare/app/navigation/routes.dart';
import 'package:trench_warfare/shared/ui_kit/corner_button.dart';

class MapSelection extends StatefulWidget {
  const MapSelection({super.key});

  @override
  State<StatefulWidget> createState() => _MapSelectionState();
}

class _MapSelectionState extends State<MapSelection> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        CornerButton(
          left: 15,
          bottom: 15,
          image: const AssetImage('assets/images/screens/shared/button_select.webp'),
          onPress: () {
            Navigator.of(context).pushNamed(Routes.gameField, arguments: 'test/7x7_win_defeat_conditions.tmx'/*'real/europe/the_battle_of_tannenburg.tmx'*/);
          },
        ),
        // Close button
        CornerButton(
          right: 15,
          bottom: 15,
          image: const AssetImage('assets/images/screens/shared/button_close.webp'),
          onPress: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
