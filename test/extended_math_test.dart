import 'dart:math';

import 'package:extended_math/extended_math.dart';

void main() {
  final i1 = Complex(re: 3, im: 3.9);
  final i2 = Complex(re: 3.1, im: 1);

  final cn = CompositeNumber(25);

  print(i1.argument);
}
