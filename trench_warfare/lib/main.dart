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

  runApp(
      EasyLocalization(
          supportedLocales: const [Locale('en')],
          path: 'assets/translations',
          fallbackLocale: const Locale('en'),
          child: const App()),
  );
}
