import 'package:extended_math/extended_math.dart';

void main() {
  final c = CentralTendency(Vector(<num>[2, 5, 3, -6, 5, 2]));
  print(c.mode()); // {2, 5}
  print(c.median()); // -1.5
}
