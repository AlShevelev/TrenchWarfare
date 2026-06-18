/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

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
import 'package:trench_warfare/shared/utils/screen_size/screen_size.dart';

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

    final screenSize = ScreenSize(context);

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
            if (screenSize.isLong) _longScreenButtons() else _shortScreenButtons(screenSize),
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

  Widget _longScreenButtons() {
    const buttonsPadding = EdgeInsets.fromLTRB(80, 0, 80, 10);

    return Column(
      children: [
        _newGameButton(buttonsPadding),
        _loadButton(buttonsPadding),
        _tutorialsButton(buttonsPadding),
        _settingsButton(buttonsPadding),
        if (kDebugMode) _testMapButton(buttonsPadding),
        if (!Logger.turnedOff) _debugLogButton(buttonsPadding),
      ],
    );
  }

  Widget _shortScreenButtons(ScreenSize screenSize) {
    final buttonsPadding = EdgeInsets.fromLTRB(
      10 * screenSize.relativeToBaseline,
      5,
      10 * screenSize.relativeToBaseline,
      5,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: _newGameButton(buttonsPadding),
              ),
              Expanded(
                child: _loadButton(buttonsPadding),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _tutorialsButton(buttonsPadding),
              ),
              Expanded(
                child: _settingsButton(buttonsPadding),
              ),
            ],
          ),
          Row(
            children: [
              if (kDebugMode)
                Expanded(
                  child: _testMapButton(buttonsPadding),
                ),
              if (!Logger.turnedOff)
                Expanded(
                  child: _debugLogButton(buttonsPadding),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _newGameButton(EdgeInsetsGeometry padding) => Padding(
        padding: padding,
        child: CoverScreenButton(
          text: localization.tr('cover_new_game'),
          onPress: () {
            Navigator.of(context).pushNamed(Routes.fromCoverToMapSelection);
          },
        ),
      );

  Widget _loadButton(EdgeInsetsGeometry padding) => Padding(
        padding: padding,
        child: CoverScreenButton(
          text: localization.tr('cover_load'),
          onPress: () {
            Navigator.of(context).pushNamed(Routes.fromCoverToLoadGame);
          },
        ),
      );

  Widget _tutorialsButton(EdgeInsetsGeometry padding) => Padding(
        padding: padding,
        child: CoverScreenButton(
          text: localization.tr('cover_tutorials'),
          onPress: () {
            Navigator.of(context).pushNamed(Routes.fromCoverToTutorials);
          },
        ),
      );

  Widget _settingsButton(EdgeInsetsGeometry padding) => Padding(
        padding: padding,
        child: CoverScreenButton(
          text: localization.tr('cover_settings'),
          onPress: () {
            Navigator.of(context).pushNamed(Routes.fromCoverToSettings);
          },
        ),
      );

  Widget _testMapButton(EdgeInsetsGeometry padding) => Padding(
        padding: padding,
        child: CoverScreenButton(
          text: 'TEST MAP',
          onPress: () {
            Navigator.of(context).pushNamed(Routes.fromMapSelectionToGameFieldNewGame,
                arguments: NewGameToGameFieldNavArg(
                  mapName: 'assets/tiles/test/15x15_balance_general.tmx',
                  selectedNation: Nation.austriaHungary,
                ));
          },
        ),
      );

  Widget _debugLogButton(EdgeInsetsGeometry padding) => Padding(
        padding: padding,
        child: CoverScreenButton(
          text: 'DEBUG LOGS',
          onPress: () {
            Navigator.of(context).pushNamed(Routes.fromCoverToDebugLogging);
          },
        ),
      );
}
