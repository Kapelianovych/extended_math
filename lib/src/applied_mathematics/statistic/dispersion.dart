import 'dart:math';

import '../../discrete_mathematics/linear_algebra/tensor/base/tensor_base.dart';
import 'quantiles/quartile.dart';

/// Class that contains methods from theory of probability distributions
class Dispersion {
  /// Creates instance of [Dispersion] with [_values]
  /// and optional [probabilities]
  ///
  /// By default means that all values have an equal propabilities if
  /// it isn't so, you can provide your own.
  Dispersion(this._values, {TensorBase? probabilities})
      : _probabilities = probabilities ??
            TensorBase.generate(_values.shape, (_) => 1 / _values.itemsCount);

  /// Possible values of random number
  final TensorBase _values;

  /// Probabilities of [values] used for `population` type methods
  final TensorBase _probabilities;

  /// Getter for [_values] that return their copy
  TensorBase get values => _values.copy();

  /// Getter for [_probabilities] that return their copy
  TensorBase get probabilities => _probabilities.copy();

  /// Computes expected value for all possible [values] of a random number
  /// for finite case with its probabilities
  double expectedValue() =>
      (values * probabilities).reduce((f, s) => f + s).toDouble();

  /// Computes `population` or `sample` [type]s of standard deviation of
  /// [values]
  double std({String type = 'population'}) =>
      type == 'sample' ? sqrt(variance(type: 'sample')) : sqrt(variance());

  /// Calculates `population` or `sample` variance of [values]
  double variance({String type = 'population'}) {
    final mu = expectedValue();

    switch (type) {
      case 'sample':
        final summ =
            (values.map((v) => pow(v - mu, 2))).reduce((f, s) => f + s);
        return summ / (values.itemsCount - 1);
      default:
        final summ = (values.map((v) => pow(v, 2)) * probabilities)
            .reduce((f, s) => f + s);
        return (summ - pow(mu, 2)).toDouble();
    }
  }

  /// Calculates `interquartile range` (IQR) of [_values]
  ///
  /// [method] to calculate quartiles [may have 3 values]
  /// (https://en.wikipedia.org/wiki/Quartile):
  ///
  ///     1. one (default)
  ///     1. two
  ///     1. three
  num iqr({String method = 'one'}) {
    final q = Quartile(_values, method: method);
    return q.third - q.first;
  }
}
