enum AppLocale {
  en,
  ru;

  static AppLocale fromString(String name) => AppLocale.values.where((v) => v.name == name).first;
}