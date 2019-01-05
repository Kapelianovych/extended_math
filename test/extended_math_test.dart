import 'dart:math';

import 'package:extended_math/extended_math.dart';

void main() {
  final i1 = Matrix(<List<num>>[
    <int>[0, 0, 1, 0],
    <int>[0, 0, 0, 2],
    <int>[0, 0, 0, 0]
  ]);

  final i2 = Matrix(<List<num>>[
    <int>[3, 2, 2],
    <int>[0, 3, 1],
    <int>[0, 3, 1],
    <int>[0, 3, 6]
  ]);

  final v1 = Vector(<int>[6, 5, 7]);
  final v2 = Vector(<int>[6, 3, 1]);

  print(i1.matrixProduct(i2));
}
