import 'dart:math';

import 'package:extended_math/extended_math.dart';

void main() {
  final v1 = Vector(<double>[3, 1, 1]);
  final v2 = Vector(<double>[-2, 5, 1]);

  print(v1.dotProduct(v2));
}
