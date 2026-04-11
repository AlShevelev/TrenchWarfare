import 'package:objectbox/objectbox.dart';

@Entity()
class CompletedGamesDbEntity {
  @Id()
  int dbId;

  String mapName;

  String nation;

  CompletedGamesDbEntity({
    this.dbId = 0,
    required this.mapName,
    required this.nation,
  });
}
