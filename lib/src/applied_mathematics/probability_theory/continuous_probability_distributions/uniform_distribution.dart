import 'dart:math';

/// Class that represent methods of continuous uniform distribution
class UniformDistribution {
  /// Creates instance of [UniformDistribution] with
  /// boundaries of possible [value]'s interval from lower [l]
  /// to upper [u] and with random [value]
  UniformDistribution(this.value, {this.l = 0, this.u = 1});

  /// Variables's value
  num value;

  /// Minimum value of random variable
  final num l;

  /// Maximum value of random variable
  final num u;

  /// Skewness of continuous uniform distribution
  final int skewness = 0;

  /// Excess kurtosis of continuous uniform distribution
  final double excessKurtosis = -6 / 5;

  /// Computes density of continuous uniform distribution
  double density() => value >= l && value <= u ? 1 / (u - l) : 0;

  /// Computes cumulative distribution of a real-valued random variable
  double cdf() {
    if (value < l) {
      return 0;
    } else if (value >= l && value <= u) {
      return (value - l) / (u - l);
    } else {
      return 1;
    }
  }

  /// Computes nth([degree]) moment of distribution
  double moment([int degree = 1]) {
    if (degree <= 0) {
      throw ArgumentError.value(
          degree, 'degree', 'Degree must be greater than zero!');
    }

    final pre = 1 / (degree + 1);
    var res = 0.0;
    for (var i = 0; i <= degree; i++) {
      res += pow(l, i) * pow(u, degree - i);
    }
    return pre * res;
  }

  /// Computes nth([degree]) central moment of distribution
  double centralMoment([int degree = 1]) {
    if (degree <= 0) {
      throw ArgumentError.value(
          degree, 'degree', 'Degree must be greater than zero!');
    }

    final up = pow(l - u, degree) + pow(u - l, degree);
    final down = pow(2, degree + 1) * (degree + 1);
    return up / down;
  }
}
