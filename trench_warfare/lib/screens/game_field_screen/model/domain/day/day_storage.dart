/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

abstract interface class DayStorageRead {
  int get day;
}

class DayStorage implements DayStorageRead {
  int _day;
  @override
  int get day => _day;

  DayStorage(int day): _day = day;

  void increaseDay() => _day++;
}