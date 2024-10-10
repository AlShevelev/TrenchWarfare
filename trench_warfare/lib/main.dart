import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart' hide Animation, Image;
import 'package:trench_warfare/database/database.dart';
import 'package:trench_warfare/shared/logger/logger_library.dart';

import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  //debugPaintSizeEnabled=true;

  await Database.start();
  Logger.init();

  FlutterError.onError = (details) {
    Logger.error(details.exception.toString(), exception: details.exception, stackTrace: details.stack);
    FlutterError.presentError(details);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    Logger.error(error.toString(), exception: error, stackTrace: stack);
    return true;
  };

  runApp(
      EasyLocalization(
          supportedLocales: const [Locale('en')],
          path: 'assets/translations',
          fallbackLocale: const Locale('en'),
          child: const App()),
  );
}
