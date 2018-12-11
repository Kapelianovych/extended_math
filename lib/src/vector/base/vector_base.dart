import '../../matrix/base/matrix_base.dart';

/// Base class for vector
abstract class VectorBase {
  /// Default constructor that don't accept data
  VectorBase();

  /// Constructor that accept [data]
  VectorBase.init(this.data);

  /// Data for vector
  List<double> data;

  /// Count of vector's numbers
  int get itemCount;

  /// Multiply this vector by [vector]
  double dot(VectorBase vector);

  /// Convert this vector to martix
  MatrixBase toMatrix();
}
