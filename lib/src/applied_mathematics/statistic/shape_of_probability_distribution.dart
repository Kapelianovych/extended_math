import 'dart:math';

import '../../discrete_mathematics/linear_algebra/tensor/base/tensor_base.dart';
import 'central_tendency.dart';

/// Shape of a probability distribution arises in questions of finding
/// an appropriate distribution to use to model the statistical properties
/// of a population, given a sample from that population. The shape of
/// a distribution may be considered either descriptively, using terms
/// such as `J-shaped`, or numerically, using quantitative measures
/// such as [skewness] and [kurtosis].
class ShapeOfProbabilityDistribution {
  /// Create instance of [ShapeOfProbabilityDistribution] with [values]
  const ShapeOfProbabilityDistribution(this.values);

  /// Variants of random number
  final TensorBase values;

  /// Skewness is a measure of the asymmetry of the probability
  /// distribution of a real-valued random variable about its mean
  double skewness() {
    final moment3 = moment(3);
    final moment2 = moment(2);
    return moment3 / pow(moment2, 1.5);
  }

  /// Computes the [degree]'s-th central moment of a [values]
  double moment(int degree) {
    final mean = CentralTendency(values).arithmetic();
    return values.map((v) => pow(v - mean, degree)).reduce((f, s) => f + s) /
        values.itemsCount;
  }

  /// Computes the kurtosis of a [values]
  ///
  /// If [excess] equal to `true`, it computes excess kurtosis
  double kurtosis({bool excess = false}) {
    final moment4 = moment(4);
    final moment2 = moment(2);
    final optionalMinus = excess ? 3 : 0;
    return moment4 / pow(moment2, 2) - optionalMinus;
  }
}
