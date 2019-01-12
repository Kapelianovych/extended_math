import 'dart:math';

import 'package:extended_math/extended_math.dart';

void main() {
  final i1 = Matrix(<List<num>>[
    <int>[0, 0, 1, 0],
    <int>[0, 0, 0, 2],
    <int>[0, 0, 0, 0]
  ]);

  final i2 = SquareMatrix(<List<int>>[
    <int>[3, 2, 2],
    <int>[0, 3, 1],
    <int>[0, 3, 1]
  ]);

  final v1 = Vector(<int>[6, 5, 7]);
  final v2 = Vector(<int>[6, 3, 1]);

  // print(i2.eigenDecomposition());

  final result = CubicEquation(a: 1, b: 80, c: -20, d: 0).calculate();
  //final result = QuadraticEquation(c: -4).calculate();
  print(result);

  // final c = Complex(re: -4);
  // final c2 = Complex(re: -4);
  // final r = c.rootsOf(2);
  // print(c / c2);
  // print(r);
  // print(Complex(re: 2).pow(2));
}
