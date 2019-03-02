import 'package:extended_math/extended_math.dart';

void main() {
  const t = Vector(
    <num>[7, 7, 21, 25, 31, 31, 47, 75, 87, 115, 116, 119, 119, 155, 177]);
  final p = Percentile(t, 33);
  print(p.ordinalRank()); // 5
  print(p.value()); // 31
}
