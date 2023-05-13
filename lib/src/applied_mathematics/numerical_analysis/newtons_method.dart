import 'dart:math';

/// **Newton's method**, also known as the **Newton–Raphson method**, named
/// after Isaac Newton and Joseph Raphson, is a root-finding algorithm which
/// produces successively better approximations to the roots (or zeroes) of a
/// real-valued function.
class NewtonsMethod {
  /// Creates instance of [NewtonsMethod] with
  /// [_equationCoef] - coefficient of function,
  /// [_equationPower] - powers of function
  /// and [epsilon] - accuracy of method
  ///
  /// ```dart
  /// final fn = '2(coef) * x^2(power) + 6(coef) * x^1(power) - 6(this can be
  /// 6(coef) * x^0(power))';
  /// ```
  NewtonsMethod(this._equationCoef, this._equationPower,
      {this.epsilon = 0.000001});

  // TODO: make parser
  // NewtonsMethod.from(String expression, {this.epsilon = 0.000001}) {
  //   final pow = '^';
  //   final multiplication = '*';
  //   final division = '/';
  //   final addition = '+';
  //   final negotiation = '-';
  //   final root = '√';

  // }

  /// Contains equation coefficients
  List<num> _equationCoef;

  /// Contains equation powers
  List<int> _equationPower;

  /// Accuracy for Newton's method
  final double epsilon;

  /// Counting Uppest limit for positive roots
  num upperLimit() {
    // Finding max negative value
    num maxModul = 0;
    for (var i = 0; i < _equationCoef.length; i++) {
      if (_equationCoef[i].abs() > maxModul) {
        maxModul = _equationCoef[i].abs();
      }
    }
    // Finding first negative number index
    var check = true;
    num powerCoef = 0;
    for (var i = 0; i < _equationCoef.length; i++) {
      if ((_equationCoef[i] < 0) && check) {
        powerCoef = i;
        check = false;
      }
    }
    final underRoot = maxModul / _equationCoef[0];
    final upLimP = 1 + pow(underRoot, 1.0 / powerCoef);
    return upLimP;
  }

  /// Counting Uppest limit for postive roots
  num _upLimPlus(List<num> coefArray) {
    // Finding max negative value
    num maxModul = 0;
    for (int i = 0; i < coefArray.length; i++) {
      if (coefArray[i].abs() > maxModul) {
        maxModul = coefArray[i].abs();
      }
    }
    // Finding first negative num index
    var check = true;
    num powerCoef = 0;
    for (var i = 0; i < coefArray.length; i++) {
      if ((coefArray[i] < 0) && check) {
        powerCoef = i;
        check = false;
      }
    }
    final underRoot = maxModul / coefArray[0];
    final upLimP = 1 + pow(underRoot, 1.0 / powerCoef);
    return upLimP;
  }

  /// Counting Lowest limit for negative roots
  num lowerLimit() {
    final helpArray = List<num>.filled(_equationCoef.length, 0);
    for (var i = 0; i < _equationCoef.length; i++) {
      if (_equationPower[i] % 2 == 0) {
        helpArray[i] = _equationCoef[i];
      } else {
        helpArray[i] = -_equationCoef[i];
      }
    }

    // First polinom coef cshoul be positive
    if (helpArray[0] < 0) {
      for (var j = 0; j < helpArray.length; j++) {
        helpArray[j] = -helpArray[j];
      }
    }
    return -_upLimPlus(helpArray);
  }

  /// Finds intervals, where sign is changing or return empty
  /// [List] if there isn't ones
  List<num> findSignChange() {
    final upLim = upperLimit();
    final lowLim = lowerLimit();
    // Choosing delta for intervals
    final delta = (upLim.abs() + lowLim.abs()) / 100;

    var point1 = lowLim;
    var point2 = lowLim + delta;
    num value1 = 0.0;
    num value2 = 0.0;

    while (point2 < upLim) {
      value1 = _calcValue(point1);
      value2 = _calcValue(point2);
      if ((value1 * value2) <= 0) {
        return <num>[point1, point2];
      }
      point1 = point2;
      point2 = point2 + delta;
    }

    return <num>[];
  }

  /// Calculating value of current function in point
  num _calcValue(num point) {
    var value = 0.0;
    for (var i = 0; i < _equationCoef.length; i++) {
      if (_equationPower[i] != 0) {
        value = value + _equationCoef[i] * pow(point, _equationPower[i]);
      } else {
        value = value + _equationCoef[i];
      }
    }
    return value;
  }

  /// Calculating value of derivative of current function in point
  num _calcDerivative(num point) {
    var value = 0.0;
    for (var i = 0; i < _equationCoef.length; i++) {
      if (_equationPower[i] != 0) {
        if (_equationPower[i] == 1) {
          value = value + _equationCoef[i];
        } else {
          value = value +
              _equationCoef[i] *
                  _equationPower[i] *
                  pow(point, _equationPower[i] - 1);
        }
      }
    }
    return value;
  }

  /// Newton's algorithm for finding root from [point]
  num calculateFrom(num point) {
    var step = point;
    var nextStep = point - _calcValue(point) / _calcDerivative(point);
    while ((nextStep - step).abs() > epsilon) {
      step = nextStep;
      nextStep = step - _calcValue(step) / _calcDerivative(step);
    }
    return nextStep;
  }
}
