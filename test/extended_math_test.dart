import 'dart:math';

import 'package:extended_math/extended_math.dart';

void main(List<String> args) {
  num equationFn(num value) {
    return pow(value, 3) - 18 * value - 83;
  }
  final p = SecantMethod(equationFn, 2, 10, 0.001);
  print(p.result());
}
