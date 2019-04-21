import 'package:extended_math/extended_math.dart';

void main() {
  final n = NewtonsMethod(<num>[1, -18, -83], <int>[3, 1, 0]);
  print(n.upperLimit()); // 84.0
  print(n.lowerLimit()); // -84.0
  print(n.findSignChange()); // [5.040000000000064, 6.720000000000064]
  print(n.calculateFrom(10)); // 5.705115796346382
}
