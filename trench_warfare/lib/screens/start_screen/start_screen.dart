import 'package:flutter/material.dart';
import 'package:trench_warfare/app/navigation/routes.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed(Routes.gameField, arguments: 'land_test.tmx');
            },
            child: const Text(
              "Start",
              textDirection: TextDirection.ltr,
            ), // Localisation is not needed - this is a temp button
          ),
        ),
    );
  }
}
