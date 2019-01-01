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
  CubicEquation({this.a = 1, this.b = 0, this.c = 0, this.d = 0}) {
    if (a == 0) {
      throw EquationException('Coefficient a shouldn\'t be equal to zero!');
    }
  }

  /// [a] coefficient in cubic equation
  num a;

  /// [b] coefficient in cubic equation
  num b;

  /// [c] coefficient in cubic equation
  num c;

  /// [d] coefficient in cubic equation
  num d;

  /// Calculates [p] in canonical cubic expression
  num get p => (c / a) - (pow(b, 2) / (3 * pow(a, 2)));

  /// Calculates [q] in canonical cubic expression
  num get q {
    final firstExpression = (2 * pow(b, 3)) / (27 * pow(a, 3));
    final secondExpression = (b * c) / (3 * pow(a, 2));
    final thirdExpression = d / a;
    return firstExpression - secondExpression + thirdExpression;
  }

  @override
  Set<num> calculate() {
    final result = Set<num>();
    final dis = discriminant();

    final possibleX = CompositeNumber(d).factorizate();
    possibleX.add(1);

    for (var item in possibleX) {
      for (var i = 1; i <= 2; i++) {
        if (evaluateForZero(pow(-1, i) * item)) {
          result.add(pow(-1, i) * item);
        }
      }
    }

    if (result.isEmpty) {
      final z =
          pow(-(q / 2) + sqrt(dis), 1 / 3) + pow(-(q / 2) - sqrt(dis), 1 / 3);
      final x = z - b / (3 * a);
      result.add(x);
    }

    final tmpB = b - -result.elementAt(0) * a;
    final tmpC = c - -result.elementAt(0) * tmpB;
    final r = d - -result.elementAt(0) * tmpC;

    if (r != 0) {
      return result;
    } else {
      try {
        final quadratic = QuadraticEquation(a: a, b: tmpB, c: tmpC);
        result.addAll(quadratic.calculate());
      } on EquationException {
        return result;
      }
    }

    return result;
  }

  @override
  num discriminant() => (pow(q, 2) / 4) + (pow(p, 3) / 27);

  @override
  bool evaluateForZero(num x) =>
      (a * pow(x, 3) + b * pow(x, 2) + c * x + d) == 0;

  @override
  String toString() => '$a * x3 + $b * x2 + $c * x + $d';
}
