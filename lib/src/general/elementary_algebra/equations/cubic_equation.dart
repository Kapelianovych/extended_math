import 'dart:math';

import '../../../complex_analysis/complex.dart';
import '../../../discrete_mathematics/general_algebraic_systems/number/double.dart';
import '../../../discrete_mathematics/general_algebraic_systems/number/integer.dart';
import 'base/equation_base.dart';
import 'exceptions/equation_exception.dart';
import 'quadratic_equation.dart';

/// Class for work with cubic equations
class CubicEquation extends EquationBase {
  /// Accepts coefficients [a], [b], [c] and [d]
  ///
  /// All values shouldn't be equal to zero. Otherwise
  /// the [EquationException] is thrown.
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
  List<Complex> calculate() {
    final result = <Complex>[];
    Complex? x1;
    final dis = discriminant();

    if (d != 0) {
      final possibleX = Integer(d.round()).factorizate();
      possibleX.add(1);

      for (var item in possibleX) {
        for (var i = 1; i <= 2; i++) {
          if (evaluate(pow(-1, i) * item, 0)) {
            x1 = Complex(re: pow(-1, i) * item);
          }
        }
      }
    } else {
      x1 = Complex();
    }

    if (x1 == null) {
      final alpha =
          Double(-(q / 2) + sqrt(dis)).preciseTo(2).rootOf(3).toDouble();
      final beta =
          Double(-(q / 2) - sqrt(dis)).preciseTo(2).rootOf(3).toDouble();
      final z = alpha + beta;
      final x = z - b / (3 * a);
      x1 = Complex(re: x);
    }

    result.add(x1);

    final tmpB = x1 * a + b;
    final tmpC = x1 * tmpB + c;

    final quadratic =
        QuadraticEquation(a: a, b: tmpB.toReal(), c: tmpC.toReal());
    final quadResult = quadratic.calculate();
    result.addAll(quadResult);

    return result;
  }

  @override
  num discriminant() => (pow(q, 2) / 4) + (pow(p, 3) / 27);

  @override
  bool evaluate(num x, num equalTo) =>
      (a * pow(x, 3) + b * pow(x, 2) + c * x + d) == equalTo;

  @override
  String toString() => '${a}x^3 + ${b}x^2 + ${c}x + $d';
}
