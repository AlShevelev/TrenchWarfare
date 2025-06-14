/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of logger;

class _TalkerDbHistory implements TalkerHistory {
  final TalkerHistoryDao _dao;

  _TalkerDbHistory({required TalkerHistoryDao dao}) : _dao = dao;

  @override
  void clean() => _dao.deleteAll();

  @override
  List<TalkerData> get history =>
      _dao.readAll().map((i) => _TalkerDataDbEntityMapper.mapFromDb(i)).toList(growable: false);

  @override
  void write(TalkerData data) {
    // We shouldn't use TalkerSettings.useHistory && TalkerSettings.maxHistoryItems here
    final dbItem = _TalkerDataDbEntityMapper.mapToDb(data);
    _dao.create(dbItem);
  }
}
