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