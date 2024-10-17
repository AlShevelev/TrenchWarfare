/// Represents relative units power
class UnitsPowerWeights {
  // An infantry attacks an armoredCar
  // Round1 0.2(from 4) infantry vs 2.95(from 4) armoredCar => 3.8 infantry unit == 1.05 armoredCar unit => 1 armored car unit == 3.62 infantry unit
  // Round2 0.15(from 4) infantry vs 3(from 4) armoredCar => 3.85 infantry unit == 1 armoredCar unit => 1 armored car unit == 3.85 infantry unit
  // Round3 0.15(from 4) infantry vs 3.05(from 4) armoredCar => 3.85 infantry unit == 0.95 armoredCar unit => 1 armored car unit == 4.05 infantry unit
  // Round4 0.15(from 4) infantry vs 2.8(from 4) armoredCar => 3.85 infantry unit == 1.2 armoredCar unit => 1.2 armored car unit == 3.21 infantry unit
  // So, 1 armoredCar unit == 3.68 infantry units
  // An armoredCar attacks an infantry
  // Round1 3.15(from 4) armoredCar vs 0(from 4) infantry => 4 infantry unit == 0.85 armoredCar unit => 1 armored car unit == 4.71 infantry unit
  // Round2 2.95(from 4) armoredCar vs 0(from 4) infantry => 4 infantry unit == 1.05 armoredCar unit => 1 armored car unit == 3.81 infantry unit
  // Round3 2.65(from 4) armoredCar vs 0(from 4) infantry => 4 infantry unit == 1.35 armoredCar unit => 1 armored car unit == 2.96 infantry unit
  // Round4 2.75(from 4) armoredCar vs 0(from 4) infantry => 4 infantry unit == 1.25 armoredCar unit => 1 armored car unit == 3.2 infantry unit
  // Total 1 armoredCar == 3.67 infantry units
  static const armoredCar = 4.0;

  // An infantry attacks an artillery
  // Round1 0(from 4) infantry vs 3.05(from 4) artillery => 4 infantry unit == 0.95 artillery unit => 1 artillery unit == 4.21 infantry unit
  // Round2 0.05(from 4) infantry vs 3(from 4) artillery => 3.95 infantry unit == 1 artillery unit
  // Round3 0(from 4) infantry vs 3(from 4) artillery => 4 infantry unit == 1 artillery unit
  // Round4 0(from 4) infantry vs 3.15(from 4) artillery => 4 infantry unit == 0.85 artillery unit => 1 artillery unit == 4.71 infantry unit
  // An artillery attacks an infantry
  // Round1 2(from 4) infantry vs 4(from 4) artillery (result is the same)
  // Total 1 artillery == 4.22 infantry units
  static const artillery = 4.0;

  static const infantry = 1.0;

  // An infantry attacks a cavalry
  // Round1 1.8(from 4) infantry vs 1.75(from 4) cavalry => 2.2 infantry unit == 2.25 cavalry unit => 1 cavalry unit == 0.98 infantry unit
  // Round2 1.9(from 4) infantry vs 2.05(from 4) cavalry => 2.1 infantry unit == 1.95 cavalry unit => 1 cavalry unit == 1.08 infantry unit
  // Round3 2.1(from 4) infantry vs 2.4(from 4) cavalry => 1.9 infantry unit == 1.6 cavalry unit => 1 cavalry unit == 1.19 infantry unit
  // Round4 2(from 4) infantry vs 2.15(from 4) cavalry => 2 infantry unit == 1.85 cavalry unit => 1 cavalry unit == 1.08 infantry unit
  // A cavalry attacks an infantry
  // Round1 0.5(from 4) cavalry vs 0(from 4) infantry => 3.5 cavalry == 4 infantry => 1 cavalry unit == 1.14 infantry unit
  // Round2 0.4(from 4) cavalry vs 0.4(from 4) infantry => 3.6 cavalry == 3.6 infantry => 1 cavalry unit == 1 infantry unit
  // Round3 0.4(from 4) cavalry vs 0.4(from 4) infantry => 3.6 cavalry == 3.6 infantry => 1 cavalry unit == 1 infantry unit
  // Round4 0.35(from 4) cavalry vs 1(from 4) infantry => 3.65 cavalry == 3 infantry => 1 cavalry unit == 0.82 infantry unit
  // Total 1 cavalry == 1.04 infantry units
  static const cavalry = 1.0;

  // An infantry attacks a machineGunnersCart
  // Round1 0.9(from 4) infantry vs 2.25(from 4) machineGunnersCart => 3.1 infantry unit == 2.75 machineGunnersCart unit => 1 machineGunnersCart unit == 1.13 infantry unit
  // Round1 1.3(from 4) infantry vs 2.5(from 4) machineGunnersCart => 2.7 infantry unit == 1.5 machineGunnersCart unit => 1 machineGunnersCart unit == 1.8 infantry unit
  // Round1 1.1(from 4) infantry vs 2.65(from 4) machineGunnersCart => 2.7 infantry unit == 1.5 machineGunnersCart unit => 1 machineGunnersCart unit == 1.8 infantry unit
  // Round1 0.95(from 4) infantry vs 2.25(from 4) machineGunnersCart => 3.05 infantry unit == 1.75 machineGunnersCart unit => 1 machineGunnersCart unit == 1.74 infantry unit
  // A machineGunnersCart attacks an infantry
  // Round1 1.75(from 4) machineGunnersCart vs 0(from 4) infantry => 2.25 machineGunnersCart unit == 4 infantry unit => 1 machineGunnersCart unit == 1.78 infantry unit
  // Round1 1.45(from 4) machineGunnersCart vs 0(from 4) infantry => 2.55 machineGunnersCart unit == 4 infantry unit => 1 machineGunnersCart unit == 1.57 infantry unit
  // Round1 1.55(from 4) machineGunnersCart vs 0(from 4) infantry => 2.45 machineGunnersCart unit == 4 infantry unit => 1 machineGunnersCart unit == 1.63 infantry unit
  // Round1 1.3(from 4) machineGunnersCart vs 0(from 4) infantry => 2.7 machineGunnersCart unit == 4 infantry unit => 1 machineGunnersCart unit == 1.48 infantry unit
  // Total 1 machineGunnersCart == 1.62 infantry units
  static const machineGunnersCart = 2.0;

  // An infantry attacks a machineGuns
  // Round1 0.95(from 4) infantry vs 2.15(from 4) machineGuns => 3.05 infantry unit == 2.85 machineGuns unit => 1 machineGuns unit == 1.07 infantry unit
  // Round1 0.9(from 4) infantry vs 2(from 4) machineGuns => 3.1 infantry unit == 2 machineGuns unit => 1 machineGuns unit == 1.55 infantry unit
  // Round1 1.1(from 4) infantry vs 2(from 4) machineGuns => 2.9 infantry unit == 2 machineGuns unit => 1 machineGuns unit == 1.45 infantry unit
  // Round1 0.85(from 4) infantry vs 2.4(from 4) machineGuns => 3.15 infantry unit == 1.6 machineGuns unit => 1 machineGuns unit == 1.97 infantry unit
  // A machineGuns attacks an infantry
  // Round1 2.85(from 4) machineGuns vs 2.55(from 4) infantry => 1.15 machineGuns unit == 1.45 infantry unit => 1 machineGuns unit == 1.26 infantry unit
  // Round1 2.9(from 4) machineGuns vs 2.5(from 4) infantry => 1.1 machineGuns unit == 1.5 infantry unit => 1 machineGuns unit == 1.36 infantry unit
  // Round1 2.65(from 4) machineGuns vs 2.6(from 4) infantry => 1.35 machineGuns unit == 1.4 infantry unit => 1 machineGuns unit == 1.04 infantry unit
  // Round1 3.05(from 4) machineGuns vs 2.6(from 4) infantry => 0.95 machineGuns unit == 1.4 infantry unit => 1 machineGuns unit == 1.47 infantry unit
  // Total 1 machineGuns == 1.4 infantry units
  static const machineGuns = 1.5;

  // An infantry attacks a tank
  // Round1 0(from 4) infantry vs 3.85(from 4) tank => 4 infantry unit == 0.15 tank unit => 1 tank unit == 26.66 infantry unit
  // Round1 0(from 4) infantry vs 4(from 4) tank (all the next rounds are the same)
  // A tank attacks an infantry
  // Round1 4(from 4) infantry vs 0(from 4) infantry (all the rounds are the same)
  static const tank = 20.0;
  
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