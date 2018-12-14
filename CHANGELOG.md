# 0.0.5

- Inner refactoring of support methods.
- Create `DiagonalMatrix` class.
- Add `isSquare()`, `isDiagonal()`, `isIdentity()`, `mainDiagonal()`, `toSquareMatrix()` and `toDiagonalMatrix()`
  methods to `MatrixBase` class.
- Add `length` getter and `crossProduct()` method to `VectorBase` class.

## 0.0.4

- Add `frobeniusNorm()` method to `MatrixBase` class.
- Add `norm()`, `euclideanNorm()`, `maxNorm()` and `angleBetween()` methods to `VectorBase` class.
- Fix `dot()` method of `VectorBase` class.

## 0.0.3

- Add `isIdentity()`, `replaceRow()` and `replaceColumn` methods to `MatrixBase` class.
- Add `inverse()`, `isSingular()` and `isNotSingular()` methods to `SquareMatrix` class.
- Fix `getDeterminant()` method.
- Small changes in classes with access to items of matrices and vectors.

## 0.0.2

- Add and implement `add()`, `subtract()` methods to `Vector` class.
- Add `SquareMatrix` class.
- Implement `getDeterminant()` methods of `SquareMatrix` class.
- Add `identity()` constructor for matrices.
- Move `generate()` constructor from `Matrix` class to `MatrixBase` and add to it
  `identity` parameter.

## 0.0.1

- Add `Vector`, `Matrix` and `Tensor` classes for working with according objects of linear algebra.
- Implements addition, subtraction, multiplication methods of `Vector` and `Matrix`.
