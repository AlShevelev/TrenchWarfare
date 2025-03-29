import 'package:easy_localization/easy_localization.dart' as localization;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:trench_warfare/app/navigation/navigation_library.dart';
import 'package:trench_warfare/app/theme/colors.dart';
import 'package:trench_warfare/app/theme/typography.dart';
import 'package:trench_warfare/core/enums/nation.dart';
import 'package:trench_warfare/screens/cover/cover_screen_button.dart';
import 'package:trench_warfare/shared/logger/logger_library.dart';

class CoverScreen extends StatefulWidget {
  const CoverScreen({super.key});

  @override
  State<StatefulWidget> createState() => _CoverScreenState();
}

class _CoverScreenState extends State<CoverScreen> {
  String? version;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      version = info.version;
    });
  }

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
            const Spacer(flex: 1),
            Padding(
              padding: buttonsPadding,
              child: CoverScreenButton(
                text: localization.tr('cover_new_game'),
                onPress: () {
                  Navigator.of(context).pushNamed(Routes.fromCoverToMapSelection);
                },
              ),
            ),
            Padding(
              padding: buttonsPadding,
              child: CoverScreenButton(
                text: localization.tr('cover_load'),
                onPress: () {
                  Navigator.of(context).pushNamed(Routes.fromCoverToLoadGame);
                },
              ),
            ),
            Padding(
              padding: buttonsPadding,
              child: CoverScreenButton(
                text: localization.tr('cover_settings'),
                onPress: () {
                  Navigator.of(context).pushNamed(Routes.fromCoverToSettings);
                },
              ),
            ),
            if (kDebugMode)
              Padding(
                padding: buttonsPadding,
                child: CoverScreenButton(
                  text: 'TEST MAP',
                  onPress: () {
                    Navigator.of(context).pushNamed(Routes.fromMapSelectionToGameFieldNewGame,
                        arguments: NewGameToGameFieldNavArg(
                          mapName: 'assets/tiles/test/7x7_win_defeat_conditions_ally_2_2.tmx',
                          selectedNation: Nation.russia,
                        ));
                  },
                ),
              ),
            if (!Logger.turnedOff)
              Padding(
                padding: buttonsPadding,
                child: CoverScreenButton(
                  text: 'DEBUG LOGS',
                  onPress: () {
                    Navigator.of(context).pushNamed(Routes.fromCoverToDebugLogging);
                  },
                ),
              ),
            DefaultTextStyle(
              style: const TextStyle(),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                child: Text(
                  version ?? '',
                  textAlign: TextAlign.end,
                  style: AppTypography.s14w400.copyWith(color: AppColors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
