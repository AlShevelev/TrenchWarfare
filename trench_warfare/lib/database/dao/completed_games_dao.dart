import 'package:trench_warfare/core/enums/nation.dart';
import 'package:trench_warfare/database/dao/dao_base.dart';
import 'package:trench_warfare/database/entities/completed_games_db_entity.dart';
import 'package:trench_warfare/database/objectbox.g.dart';

class CompletedGamesDao extends DaoBase {
  final Box<CompletedGamesDbEntity> _box;

  CompletedGamesDao({required Box<CompletedGamesDbEntity> box}) : _box = box;

  void markGameAsCompleted(String mapName, Nation nation) {
    final query = _box.query(CompletedGamesDbEntity_.mapName
        .equals(mapName)
        .and(CompletedGamesDbEntity_.nation.equals(nation.toString())));

    var dbRecord = readFirst(query);

    if (dbRecord != null) {
      return;
    }

    put(_box, CompletedGamesDbEntity(mapName: mapName, nation: nation.toString()));
  }

  List<CompletedGamesDbEntity> readAll() => read(_box.query());
}
