
/// This is the so-called Cantor pairing function
/// https://en.wikipedia.org/wiki/Pairing_function#Cantor_pairing_function
int pair(int a, int b) {
  final c = a + b;
  final d = c + 1;

  return ((c * d) >> 1) + b;
}