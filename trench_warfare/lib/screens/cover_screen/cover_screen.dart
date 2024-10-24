import 'package:easy_localization/easy_localization.dart' as localization;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:trench_warfare/app/navigation/routes.dart';
import 'package:trench_warfare/screens/cover_screen/cover_screen_button.dart';

class CoverScreen extends StatelessWidget {
  const CoverScreen({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final locale = localization.EasyLocalization.of(context)?.locale;

    const buttonsPadding = EdgeInsets.fromLTRB(80, 0, 80, 10);

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/screens/cover/cover_background.webp"),
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: Image.asset("assets/images/screens/cover/cover_title_$locale.webp"),
              ),
              const Spacer(flex: 1,),
              Padding(
                padding: buttonsPadding,
                child: CoverScreenButton(
                  text: localization.tr('cover_new_game'),
                  onPress: () {
                    Navigator.of(context).pushNamed(Routes.gameField, arguments: 'real/europe/the_battle_of_tannenburg.tmx');
                  },
                ),
              ),
              Padding(
                padding: buttonsPadding,
                child: CoverScreenButton(
                  text: localization.tr('cover_load'),
                  onPress: () { },
                ),
              ),
              Padding(
                padding: buttonsPadding,
                child: CoverScreenButton(
                  text: localization.tr('cover_settings'),
                  onPress: () { },
                ),
              ),
              if (kDebugMode)
                Padding(
                  padding: buttonsPadding,
                  child: CoverScreenButton(
                    text: 'DEBUG LOGS',
                    onPress: () {
                      Navigator.of(context).pushNamed(Routes.debugLogging);
                    },
                  ),
                ),
            ],
          ),
        ),
    );
  }
}
