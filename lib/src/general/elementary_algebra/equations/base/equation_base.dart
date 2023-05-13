import '../../../../complex_analysis/complex.dart';

/// Class defining methods for equation expressions
abstract class EquationBase {
  /// Calculates `x1...xn` for this expression
  ///
  /// Any real roots are converted to [Complex] numbers and can
  /// be resolved with [Complex.toReal] method.
  List<Complex> calculate();

  /// Gets discriminant of equation
  num discriminant();

  /// Evaluates the expression with given [x] to [equalTo] value
  bool evaluate(num x, num equalTo);
}
