/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of audio;

enum SoundType {
  attackShot,
  attackExplosion,
  attackFlame,
  attackGas,
  attackFlechettes,
  attackPropagandaSuccess,
  attackPropagandaFail,

  battleResultVictory,
  battleResultDefeat,
  battleResultPcCaptured,
  battleResultManDeath,
  battleResultMechanicalDestroyed,
  battleResultShipDestroyed,

  productionCavalry,
  productionInfantry,
  productionMechanical,
  productionPC,
  productionShip,

  buttonClick,
  dingUniversal,
}
