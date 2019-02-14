import 'dart:math';

/// Class that represent methods of unoform distribution
class UniformDistribution {
  /// Creates instance of [UniformDistribution] with boundaries of possible value's interval 
  UniformDistribution(this.value, {this.a = 0, this.b = 1});

  /// Variable's value
  num value;

  /// Minimum value of random variable
  num a;

  /// Maximum value of random variable
  num b;

  /// Computes density of continuous uniform distribution
  double density() => value >= a && value <= b ? 1 / (b - a) : 0;

  /// Computes cumulative distribution of a real-valued random variable 
  double cdf() {
    if (value < a) {
      return 0;
    } else if (value >= a && value <= b) {
      return (value - a) / (b - a);
    } else {
      return 1;
    }
  }

  /// Computes nth([degree]) raw moment of distribution
  double rawMoment([int degree = 1]) {
    if (degree <= 0) {
      throw ArgumentError.value(degree, 'degree', 'Degree must be greater than zero!');
    }

    final pre = 1 / (degree + 1);
    var res = 0.0;
    for (var i = 0; i <= degree; i++) {
      res += pow(a, i) * pow(b, degree - i);
    }
    return pre * res;
  }

  /// Computes nth([degree]) central moment of distribution
  double centralMoment([int degree = 1]) {
    if (degree <= 0) {
      throw ArgumentError.value(degree, 'degree', 'Degree must be greater than zero!');
    }

    final up = pow(a - b, degree) + pow(b - a, degree);
    final down = pow(2, degree + 1) * (degree + 1);
    return up / down;
  }
}