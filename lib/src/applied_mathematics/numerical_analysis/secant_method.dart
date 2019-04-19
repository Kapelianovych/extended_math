/// Root-finding algorithm that uses a succession of roots of secant lines to
/// better approximate a root of a function.
///
/// [More info](https://en.wikipedia.org/wiki/Secant_method)
class SecantMethod {
  /// Creates instance of [SecantMethod] with [x0] and [x1] as initial values,
  /// which should ideally be chosen to lie close to the root; [e] - accuracy of
  /// the result;
  ///
  /// [equationFn] - function for which the root need to be found.
  /// Must be like:
  /// ```dart
  /// num equationFn(num x){
  ///   return pow(x, 3) - 18 * x - 83; // example
  /// }
  /// ```
  SecantMethod(this.equationFn, this.x0, this.x1, this.e);

  /// Initial value 0
  num x0;

  /// Initial value 1
  num x1;

  /// Accuracy of result
  num e;

  /// Function for which the root need to be found
  num Function(num value) equationFn;

  /// Get number that is root of the [equationFn]
  num result() {
    num xNext = 0;
    var xPrevious = x0;
    var xCurrent = x1;
    num tmp = 0;

    do {
      tmp = xNext;
      xNext = xCurrent -
          equationFn(xCurrent) *
              (xPrevious - xCurrent) /
              (equationFn(xPrevious) - equationFn(xCurrent));
      xPrevious = xCurrent;
      xCurrent = tmp;
    } while ((xNext - xCurrent).abs() > e);
    return xNext;
  }
}
