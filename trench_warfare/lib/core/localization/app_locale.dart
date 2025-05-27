/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

enum AppLocale {
  en,
  ru;

  static AppLocale fromString(String name) => AppLocale.values.where((v) => v.name == name).first;
}