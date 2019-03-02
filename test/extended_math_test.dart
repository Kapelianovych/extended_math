import 'package:extended_math/extended_math.dart';

void main() {
  const t = ShapeOfProbabilityDistribution(Vector(<num>[8, 5, 3]));
  print(t.moment(2));
  print(t.skewness());
  print(t.kurtosis());
  print(t.kurtosis(excess: true));
}
