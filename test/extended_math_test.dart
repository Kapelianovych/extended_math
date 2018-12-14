import 'dart:math';

import 'package:extended_math/extended_math.dart';

void main() {
  final v1 = DiagonalMatrix(<List<double>>[
    <double>[2, 0, 0],
    <double>[0, 8, 0],
    <double>[0, 0, 5]
  ]);

  final v2 = Vector(<double>[-2, 5, 1]);

  // [[0.5, -0.0, 0.0], [-0.0, 0.125, -0.0], [0.0, -0.0, 0.2]]
  //print(v1.inverse().data);

  final m = SquareMatrix(<List<double>>[
    <double>[1, 0],
    <double>[6, 1]
  ]);
  print(m.isOrthogonal());
}
