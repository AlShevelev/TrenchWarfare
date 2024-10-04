import 'package:flutter/material.dart';
import 'package:trench_warfare/app/navigation/routes.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  //Navigator.of(context).pushNamed(Routes.gameField, arguments: 'test/15x15_carriers_enemy_pc_reachable_by_water_only.tmx');
                  //Navigator.of(context).pushNamed(Routes.gameField, arguments: 'test/40x40_land.tmx');
                  //Navigator.of(context).pushNamed(Routes.gameField, arguments: 'test/7x7_win_defeat_conditions.tmx');
                  Navigator.of(context).pushNamed(Routes.gameField, arguments: 'real/europe/the_battle_of_tannenburg.tmx');
                },
                child: const Text(
                  "Start",
                  style: TextStyle(color: Colors.black),
                  textDirection: TextDirection.ltr,
                ), // Localisation is not needed - this is a temp button
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(Routes.debugLogging);
                },
                child: const Text(
                  "Logs",
                  style: TextStyle(color: Colors.black),
                  textDirection: TextDirection.ltr,
                ), // Localisation is not needed - this is a temp button
              ),
            ],
          ),
        ),
    );
  }
}
