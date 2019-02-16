import 'dart:math';

import '../../discrete_mathematics/linear_algebra/tensor/base/tensor_base.dart';

/// Class that contains methods from theory of probability distributions
class TheoryOfProbabilityDistributions {
  /// Creates instance of [TheoryOfProbabilityDistributions] with [_values] and optional [probabilities]
  ///
  /// By default means that all values have an equal propabilities if it isn't so, you can provide your own.
  TheoryOfProbabilityDistributions(this._values, {TensorBase probabilities}) {
    _probabilities = probabilities ??
        TensorBase.generate(values.shape, (_) => 1 / values.itemsCount);
  }

  /// Possible values of random number
  TensorBase _values;

  /// Probabilities of [values]
  TensorBase _probabilities;

  /// Getter for [_values] that return their copy
  TensorBase get values => _values.copy();

  /// Getter for [_probabilities] that return their copy
  TensorBase get probabilities => _probabilities.copy();

  /// Computes expected value for all possible [values] of a random number for finite case with its probabilities
  double expectedValue() => (values * probabilities).reduce((f, s) => f + s);

  /// Computes standard deviation of [values] with its probabilities
  double sd() => sqrt(variance());

  /// Calculates variance of [values] with its probabilities
  double variance() {
    final mu = expectedValue();
    final summ =
        (values.map((v) => pow(v, 2)) * probabilities).reduce((f, s) => f + s);
    return summ - pow(mu, 2);
  }
}
