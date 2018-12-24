/// Class defining methods for equation expressions
abstract class EquationBase {
  /// Calculates x1...xn for this expression
  Set<double> calculate();

  /// Gets discriminant of equation
  double discriminant();

  /// Evaluates the expression for zero
  bool evaluateForZero(double x);
}
