part of money_calculators;

/// Represents relative units power
class UnitsPowerWeights {
  // An infantry attacks an armoredCar
  // Round1 0.2(from 4) infantry vs 2.95(from 4) armoredCar => 1 armored car unit == 3.62 infantry unit
  // Round2 0.15(from 4) infantry vs 2.6(from 4) armoredCar => 1 armored car unit == 2.7 infantry unit
  // Round3 0.2(from 4) infantry vs 2.7(from 4) armoredCar => 1 armored car unit == 2.92 infantry unit
  // Round4 0.15(from 4) infantry vs 2.9(from 4) armoredCar => 1 armored car unit == 3.5 infantry unit
  // So, 1 armoredCar unit == 3.68 infantry units
  // An armoredCar attacks an infantry
  // Round1 2.65(from 4) armoredCar vs 0(from 4) infantry => 1 armored car unit == 2.96 infantry unit
  // Round2 2.7(from 4) armoredCar vs 0(from 4) infantry => 1 armored car unit == 3.08 infantry unit
  // Round3 2.65(from 4) armoredCar vs 0(from 4) infantry => 1 armored car unit == 2.96 infantry unit
  // Round4 3(from 4) armoredCar vs 0(from 4) infantry => 1 armored car unit == 3.2 infantry unit
  static const armoredCar = 3.0;

  // An infantry attacks an artillery
  // Round1 0.05(from 4) infantry vs 3(from 4) artillery => 3.95 artillery unit == 3.95 infantry unit
  // Round2 0(from 4) infantry vs 3.2(from 4) artillery => 5 infantry unit == 5 artillery unit
  // Round3 0(from 4) infantry vs 2.7(from 4) artillery => 3 infantry unit == 3 artillery unit
  // Round4 0(from 4) infantry vs 3(from 4) artillery => 4 artillery unit == 4 infantry unit
  // An artillery attacks an infantry
  // Round1 2(from 4) infantry vs 4(from 4) artillery (result is the same)
  // Total 1 artillery == 4.22 infantry units
  static const artillery = 3.5;

  static const infantry = 1.0;

  // An infantry attacks a cavalry
  // Round1 1.8(from 4) infantry vs 1.75(from 4) cavalry => 1 cavalry unit == 0.98 infantry unit
  // Round2 1.9(from 4) infantry vs 2.05(from 4) cavalry => 1 cavalry unit == 1.08 infantry unit
  // Round3 2.1(from 4) infantry vs 2.4(from 4) cavalry => 1 cavalry unit == 1.19 infantry unit
  // Round4 2(from 4) infantry vs 2.15(from 4) cavalry => 1 cavalry unit == 1.08 infantry unit
  // A cavalry attacks an infantry
  // Round1 0.5(from 4) cavalry vs 0(from 4) infantry => 1 cavalry unit == 1.14 infantry unit
  // Round2 0.4(from 4) cavalry vs 0.4(from 4) infantry => 1 cavalry unit == 1 infantry unit
  // Round3 0.4(from 4) cavalry vs 0.4(from 4) infantry => 1 cavalry unit == 1 infantry unit
  // Round4 0.35(from 4) cavalry vs 1(from 4) infantry => 1 cavalry unit == 0.82 infantry unit
  // Total 1 cavalry == 1.04 infantry units
  static const cavalry = 1.5;

  // An infantry attacks a machineGunnersCart
  // Round1 1.1(from 4) infantry vs 2(from 4) machineGunnersCart => 1 machineGunnersCart unit == 1.45 infantry unit
  // Round1 1.65(from 4) infantry vs 2(from 4) machineGunnersCart => 1 machineGunnersCart unit == 1.175 infantry unit
  // A machineGunnersCart attacks an infantry
  // Round1 0.6(from 4) machineGunnersCart vs 0(from 4) infantry => 1 machineGunnersCart unit == 1.17 infantry unit
  // Round1 0.45(from 4) machineGunnersCart vs 0(from 4) infantry => 1 machineGunnersCart unit == 1.27 infantry unit
  // Total 1 machineGunnersCart == 1.62 infantry units
  static const machineGunnersCart = 1.5;

  // An infantry attacks a machineGuns
  // Round1 1.35(from 4) infantry vs 2.(from 4) machineGuns => 1 machineGuns unit == 1.325 infantry unit
  // Round1 1.1(from 4) infantry vs 1.75(from 4) machineGuns => 1 machineGuns unit == 1.29 infantry unit
  // A machineGuns attacks an infantry
  // Round1 3.05(from 4) machineGuns vs 2.6(from 4) infantry => 1 machineGuns unit == 1.47 infantry unit
  // Round1 2.95(from 4) machineGuns vs 2.55(from 4) infantry => 1 machineGuns unit == 1.38 infantry unit
  // Total 1 machineGuns == 1.4 infantry units
  static const machineGuns = 1.5;

  // An infantry attacks a tank
  // Round1 0(from 4) infantry vs 3.85(from 4) tank => 1 tank unit == 26.66 infantry unit
  // Round1 0(from 4) infantry vs 4(from 4) tank (all the next rounds are the same)
  // A tank attacks an infantry
  // Round1 4(from 4) infantry vs 0(from 4) infantry (all the rounds are the same)
  static const tank = 15.0;
  
  static const destroyer = 1.0;

  // A destroyer attacks a cruiser
  // Round1 0(from 4) destroyer vs 2.25(from 4) cruiser (all the rounds are same) => 4 destroyer unit == 1.75 cruiser unit => 1 cruiser == 2.29 destroyer unit
  // A cruiser attacks a destroyer
  // Round1 3.15(from 4) cruiser vs 0(from 4) destroyer (all the rounds are same) => 4 destroyer unit == 0.85 cruiser unit => 1 cruiser == 4.7 destroyer unit
  // Round1 3.25(from 4) cruiser vs 0(from 4) destroyer (all the rounds are same) => 4 destroyer unit == 0.75 cruiser unit => 1 cruiser == 5.33 destroyer unit
  // Total 1 cruiser == 3.19 destroyer
  static const cruiser = 3.0;

  // A destroyer attacks a battleship
  // Round1 0(from 4) destroyer vs 3.75(from 4) battleship => 4 destroyer unit == 0.25 battleship unit => 1 cruiser == 2.29 destroyer unit
  // Round1 0(from 4) destroyer vs 3.7(from 4) battleship
  // Round1 0(from 4) destroyer vs 3.65(from 4) battleship
  // Round1 0(from 4) destroyer vs 3.7(from 4) battleship
  // A battleship attacks a destroyer
  // Round1 0(from 4) destroyer vs 4(from 4) battleship (all rounds are the same)
  // Total 1 battleship == 16 destroyers
  static const battleship = 15.0;

  static const carrier = 3.0;
}