import 'dart:math';

import 'base/equation_base.dart';
import 'exceptions/equation_exception.dart';

/// Class for work with quadratic equations
class QuadraticEquation extends EquationBase {
  /// Accepts coefficients [a], [b] and [c]
  ///
  /// [a] value shouldn't be equal to zero. Otherwise the [EquationException] is thrown.
  QuadraticEquation(double a, {this.b, this.c}) {
    if (a == 0) {
      throw EquationException('Coefficient a shouldn\'t be equal to zero!');
    } else {
      this.a = a;
    }
  }

  /// [a] coefficient in quadratic equation
  double a;

  /// [b] coefficient in quadratic equation
  double b = 0;

  /// [c] coefficient in quadratic equation
  double c = 0;

  @override
  Set<double> calculate() {
    final result = Set<double>();
    final dis = discriminant();

    if (dis > 0) {
      for (var i = 1; i <= 2; i++) {
        result.add((-b + pow(-1, i) * sqrt(dis)) / 2 * a);
      }
    } else if (dis == 0) {
      result.add(-b / 2 * a);
    } else {
      throw EquationException(
          'Expression haven\'t solutions, because of discriminant is less than zero!');
    }
    return result;
  }

  @override
  double discriminant() => pow(b, 2) - 4 * a * c;

  @override
  bool evaluateForZero(double x) => (a * pow(x, 2) + b * x + c) == 0;

  @override
  String toString() => '$a * x2 + $b * x + $c';
}
