import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trench_warfare/app/app_lifecycle_observer.dart';
import 'package:trench_warfare/app/navigation/navigation_library.dart';
import 'package:trench_warfare/app/theme/theme.dart';
import 'package:trench_warfare/screens/cover/cover_screen.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    return AppLifecycleObserver(
      child: MaterialApp(
        title: 'Trench warfare',
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: AppThemeFactory.defaultTheme(),
        onGenerateRoute: (settings) => Routes.createPageRouteBuilder(settings),
        home: const CoverScreen(),
      ),
    );
  }
}
