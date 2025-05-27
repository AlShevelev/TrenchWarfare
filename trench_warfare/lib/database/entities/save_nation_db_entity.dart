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
class SaveNationDbEntity {
  @Id()
  int dbId;

  /// A link to [SaveSlotDbEntity]
  int slotDbId;

  bool isHuman;

  /// An order of the nation in the player list (from zero)
  int playingOrder;

  /// An item's index in [Nation] enum
  int nation;

  int day;

  bool defeated;

  bool isSideOfConflict;

  int totalSumCurrency;

  int totalSumIndustryPoints;

  int totalIncomeCurrency;

  int totalIncomeIndustryPoints;

  int totalExpensesCurrency;

  int totalExpensesIndustryPoints;

  SaveNationDbEntity({
    this.dbId = 0,
    required this.slotDbId,
    required this.isHuman,
    required this.playingOrder,
    required this.nation,
    required this.day,
    required this.defeated,
    required this.isSideOfConflict,
    required this.totalSumCurrency,
    required this.totalSumIndustryPoints,
    required this.totalIncomeCurrency,
    required this.totalIncomeIndustryPoints,
    required this.totalExpensesCurrency,
    required this.totalExpensesIndustryPoints,
  });
}
