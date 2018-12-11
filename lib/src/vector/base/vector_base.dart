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

  /// Add this vector to [vector]
  VectorBase add(VectorBase vector);

  /// Subtract this vector from [vector]
  VectorBase subtract(VectorBase vector);

  /// Convert this vector to martix
  MatrixBase toMatrix();
}
