/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

import 'package:objectbox/objectbox.dart';

@Entity()
class CompletedGamesDbEntity {
  @Id()
  int dbId;

  /// Full name of the map (for example: assets/tiles/real/europe/battle_of_tannenburg.tmx)
  String mapName;

  String nation;

  CompletedGamesDbEntity({
    this.dbId = 0,
    required this.mapName,
    required this.nation,
  });
}
