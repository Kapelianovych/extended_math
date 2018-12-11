/// Library for working with objects of linear algebra.
///
/// Contains 3 base classes:
///
///   1. Vector
///   2. Matrix
///   3. Tensor
///
/// Each class have vary implementations that have methods of working with them.
library extended_math;

export 'src/exceptions/matrix_exception.dart';
export 'src/exceptions/vector_exception.dart';

export 'src/matrix/base/matrix_base.dart';
export 'src/matrix/matrix.dart';
export 'src/matrix/square_matrix.dart';
export 'src/tensor/base/tensor_base.dart';
export 'src/tensor/tensor.dart';
export 'src/vector/base/vector_base.dart';
export 'src/vector/vector.dart';
