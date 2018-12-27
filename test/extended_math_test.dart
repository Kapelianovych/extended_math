import 'dart:math';

import 'package:extended_math/extended_math.dart';

void main() {
  final v1 = DiagonalMatrix(<List<double>>[
    <double>[2, 0, 0],
    <double>[0, 8, 0],
    <double>[0, 0, 5]
  ]);

  final v2 = Vector(<double>[-2, 5, 1]);
  final v3 = Vector(<double>[-1, 4, 3]);

  // [[0.5, -0.0, 0.0], [-0.0, 0.125, -0.0], [0.0, -0.0, 0.2]]
  // print(v1.inverse().data);

  final m = SquareMatrix(<List<double>>[
    <double>[1, 2, 1, 13],
    <double>[4, 3, -2, 56],
    <double>[3, 2, 1, 33],
    <double>[7, 9, 15, 11]
  ]);
  final m1 = SquareMatrix(<List<double>>[
    <double>[2, 4, 7],
    <double>[1, 9, 2],
    <double>[5, 3, 5]
  ]);
  // print(m.eliminate(<double>[8, 4, 10, 13]).data);
  // print(m1.insertRow(<double>[1, 2], index: 1).data);

  // print(NumbersGenerator().nextDouble(from: -0.4, to: 0.7));
  // print(DiagonalMatrix.generate(2, fillRandom: true).data);
  print(CompositeNumber(66).isPrime());
}
