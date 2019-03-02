/// Class that cut points dividing the range of a probability distribution
/// into continuous intervals with equal probabilities, or dividing
/// the observations in a sample in the same way
class Quantile {
  /// Constructor that defines [q] of quantile
  const Quantile(this.q);

  /// Value that partition a finite set of values into [q]
  /// subsets of (nearly) equal sizes
  final int q;
}
