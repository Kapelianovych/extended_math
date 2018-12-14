import '../utils/utils.dart';
import '../vector/base/vector_base.dart';
import 'square_matrix.dart';

/// Class for work with numeric diagonal matrix
class DiagonalMatrix extends SquareMatrix {
  /// Constructor accept array of arrays of double numbers
  ///
  /// Count of inner arrays must be equal to count of their elements!
  /// All elements of matrix except elements of main diagonal must be equal to zero!
  DiagonalMatrix(List<List<double>> data) : super(data);

  /// Creates non square diagonal matrix
  ///
  /// All elements of matrix except elements of main diagonal must be equal to zero!
  DiagonalMatrix.nonSquare(List<List<double>> data)
      : super(<List<double>>[
          <double>[1]
        ]) {
    this.data = data;
  }

  /// Create identity matrix
  DiagonalMatrix.identity(int number) : super.identity(number);

  /// Generate matrix with specified [number] of rows and columns
  ///
  /// If [fillRandom] is true, then main diagonal of matrix will filled with random numbers,
  /// otherwise main diagonal of matrix will have all values defaults to 1.
  DiagonalMatrix.generate(int number, {bool fillRandom = false})
      : super.identity(number) {
    if (fillRandom == true) {
      for (var j = 1; j <= number; j++) {
        setItem(j, j, generateNumbers(number).take(1).single);
      }
    }
  }
}
