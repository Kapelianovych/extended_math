/// Class defining methods for equation expressions
abstract class EquationBase {
  /// Calculates x1...xn for this expression
  Set<num> calculate();

  /// Gets discriminant of equation
  num discriminant();

  /// Evaluates the expression for zero
  bool evaluateForZero(num x);
}
