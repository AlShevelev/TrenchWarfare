import 'package:trench_warfare/core/enums/nation.dart';

extension NationExt on Nation {
  String get image => 'assets/images/screens/shared/banners/$name.webp';
}
