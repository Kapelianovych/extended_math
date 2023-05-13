import 'dart:math';

import '../../../complex_analysis/complex.dart';
import 'base/equation_base.dart';
import 'exceptions/equation_exception.dart';

/// Class for work with quadratic equations
class QuadraticEquation extends EquationBase {
  /// Accepts coefficients [a], [b] and [c]
  ///
  /// [a] value shouldn't be equal to zero. Otherwise
  /// the [EquationException] is thrown.
  QuadraticEquation({this.a = 1, this.b = 0, this.c = 0}) {
    if (a == 0) {
      throw EquationException('Coefficient a shouldn\'t be equal to zero!');
    }
  }

  /// [a] coefficient in quadratic equation
  num a;

  /// [b] coefficient in quadratic equation
  num b;

  /// [c] coefficient in quadratic equation
  num c;

  @override
  List<Complex> calculate() {
    final result = <Complex>[];
    final dis = discriminant();

    if (dis > 0) {
      for (var i = 1; i <= 2; i++) {
        result.add(Complex(re: (-b + pow(-1, i) * sqrt(dis)) / (2 * a)));
      }
    } else if (dis == 0) {
      result.add(Complex(re: -b / (2 * a)));
    } else {
      for (var i = 1; i <= 2; i++) {
        final re = -b / (2 * a);
        final im = pow(-1, i) * sqrt(-dis) / (2 * a);
        result.add(Complex(re: re, im: im));
      }
    }
    return result;
  }

  @override
  num discriminant() => pow(b, 2) - 4 * a * c;

  @override
  bool evaluate(num x, num equalTo) => (a * pow(x, 2) + b * x + c) == equalTo;

  @override
  String toString() => '${a}x^2 + ${b}x + $c';
}
