enum AppLocale {
  en;

  static AppLocale fromString(String name) => AppLocale.values.where((v) => v.name == name).first;
}