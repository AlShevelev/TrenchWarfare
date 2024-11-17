import 'package:trench_warfare/core_entities/enums/nation.dart';

extension NationExt on Nation {
  String get image => 'assets/images/screens/shared/banners/$name.webp';
}
