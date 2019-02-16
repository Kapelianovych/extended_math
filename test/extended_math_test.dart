import 'package:extended_math/extended_math.dart';

void main() {
  final c = Mean(Vector(<num>[8, 5, 3]));
  print(c.arithmetic(weights: Vector(<num>[.25, .5, .25]))); // 5.25
  print(c.geometric(weights: Vector(<num>[.25, .5, .25]))); // 4.949232003839765
  print(c.harmonic(weights: Vector(<num>[.25, .5, .25]))); // 4.660194174757281
  print(c.quadratic()); // 5.715476066494082

  // It is common algorithm for all above means
  print(c.generalized(2)); // 5.715476068195464
}
