import 'dart:math';

import '../../discrete_mathematics/number_theory/composite_number.dart';
import 'base/equation_base.dart';
import 'exceptions/equation_exception.dart';
import 'quadratic_equation.dart';

/// Class for work with cubic equations
class CubicEquation extends EquationBase {
  /// Accepts coefficients [a], [b], [c] and [d]
  ///
  /// All values shouldn't be equal to zero. Otherwise the [EquationException] is thrown.
  CubicEquation(double a, {this.b, this.c, this.d}) {
    if (a == 0) {
      throw EquationException('Coefficient a shouldn\'t be equal to zero!');
    } else {
      this.a = a;
    }
  }

  /// [a] coefficient in cubic equation
  double a;

  /// [b] coefficient in cubic equation
  double b = 0;

  /// [c] coefficient in cubic equation
  double c = 0;

  /// [d] coefficient in cubic equation
  double d = 0;

  /// Calculates [p] in canonical cubic expression
  double get p => (c / a) - (pow(b, 2) / 3 * pow(a, 2));

  /// Calculates [q] in canonical cubic expression
  double get q {
    final firstExpression = 2 * pow(b, 3) / 27 * pow(a, 3);
    final secondExpression = b * c / 3 * pow(a, 2);
    final thirdExpression = d / a;
    return firstExpression - secondExpression + thirdExpression;
  }

  @override
  Set<double> calculate() {
    final result = Set<double>();
    final dis = discriminant();

    if (dis == 0 || dis < 0) {
      final possibleX = CompositeNumber(d).factorizate();
      possibleX.add(1);

      for (var item in possibleX) {
        for (var i = 1; i <= 2; i++) {
          if (evaluateForZero(pow(-1, i) * item)) {
            result.add(pow(-1, i) * item);
          }
        }
      }
    } else {
      final z =
          pow(-(q / 2) + sqrt(dis), 1 / 3) + pow(-(q / 2) - sqrt(dis), 1 / 3);
      final x = z - b / 3 * a;
      result.add(x);
    }

    final tmpB = b - -result.elementAt(0) * a;
    var tmpC = c - -result.elementAt(0) * tmpB;

    // Don't handle complex roots
    if (d - -result.elementAt(0) * tmpC == 0) {
      final quadratic = QuadraticEquation(a, b: tmpB, c: tmpC);
      result.addAll(quadratic.calculate());
    }

    return result;
  }

  @override
  double discriminant() => (pow(q, 2) / 4) + (pow(p, 3) / 27);

  @override
  bool evaluateForZero(double x) =>
      (a * pow(x, 3) + b * pow(x, 2) + c * x + d) == 0;

  @override
  String toString() => '$a * x3 + $b * x2 + $c * x + $d';
}
