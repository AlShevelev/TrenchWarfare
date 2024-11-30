// DO NOT SWAP THE ELEMENTS - OTHERWISE THE SAVED GAMES MAY BE CORRUPTED
// A NEW ELEMENT MUST BE ADDED TO THE END OF THE LIST
enum UnitExperienceRank {
  rookies,
  fighters,
  proficients,
  veterans,
  elite;

  static double asNumber(UnitExperienceRank rank) => switch (rank) {
    UnitExperienceRank.rookies => 1,
    UnitExperienceRank.fighters => 2,
    UnitExperienceRank.proficients => 3,
    UnitExperienceRank.veterans => 4,
    UnitExperienceRank.elite => 5,
  };
}