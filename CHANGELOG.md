# 0.0.17

- Add `reduce()`, `any()`, `every()`, `map()`, `toList()` methods to `TensorBase` class.
- Add `TensorBase.generate` constructor and to its subclasses.
- Rename `transform()` method of `Vactor` and `Matrix` to `map()`.
- Add `statistic` subsection with `Mean` class.
- Add `itemAt()` and `setItem()` methods to `Tensor3` and `Tensor4` classes.

## 0.0.16+1

- Fix `preciseTo()` method of `Double` class.

## 0.0.16

- Add `Tensor3` class for work with three-dimensional tensors.
- Remove `VectorBase`, `MatrixBase` classes.
- Add `TensorException` class.

## 0.0.15

- Moves functionality of `CompositeNumber` class to `Integer` class.

## 0.0.14+1

- Downgrade required Dart SDK to `2.1.0-dev.9.4`.

## 0.0.14

- Remove `Complex.toComplex()` constructor.
- Rewrite `calculate()` method of `EquationBase` class to calculate complex roots.
- Change return object of `eigenDecomposition()` method of `SquareMatrix` class.
- Fix `calculate()` method of `CubicEquation` class.
- Allow `*` and `/` operators of `Complex` class for work with real numbers.
- Create `CopyableMixin` which extends `MatrixBase`, `VectorBase` and `Complex` classes.
- Add `isReal()`, `conjugate()` and `toReal()` methods to `Complex` class.
- Change `rootsOf()` method of `Complex` class to return all roots.
- Add `Number`, `Integer` and `Double` classes in subsuction of discrete mathematics.
- Implement `*`, `/`, `+` and `-` operators for new types.
- Small changes in README.

## 0.0.13

- Rename `multiplyByMatrix()` to `matrixProduct()` of `MatrixBase` class.
- Fix `gaussian()` method.
- Add `eigenDecomposition()` method to `SquareMatrix` class.
- Add `svd()` method to `MatrixBase` class.

## 0.0.12

- Add `swapRows()`, `swapColumns()`, `submatrix()`, `gaussian()`, `rank()` and `isUpperTriangle()` methods to `MatrixBase` class.
- Distinct `insert(Row/Column)()` to `(replace/append)(Row/Column)()` methods of `MatrixBase` class.
- Split `toMatrix()` mathod of `VectorBase` class to `toMatrix(Row/Column)()` methods.
- Move `/` operator to `SquareMatrix` class from `MatrixBase`.
- Removes `_multiplyByVector()` method from `MatrixBase` class.
- Change methods for work with rows and columns of matrix to work with self instance.
- Set `data` to private and create getter with the same name which returns copy of `data`.
- Add `CONTRIBUTING.md`.

## 0.0.11

- Removes overridden `multiplyByVector()` method in `DiagonalMatrix` class.
- Change `multiplyByVector()` and `multiplyBy()` methods to private methods.
- Comment `eigenDecomposition()` and `svd()` methods of `SquareMatrix` class - they aren't finished.
- Rename `I` class to `Complex` class.
- Implement `rootOf()` and `pow()` methods of `Complex` class.

## 0.0.10

- Fix `QuadraticEquation`'s and `CubicEquation`'s `calculate()` method.
- Fix `factorizate()` method of `CompositeNumber` class.
- Implement `*`, `/`, `+` and `-` operators for complex number `I`.
- Add `module`, `argument` getters to `I` class.
- Changed `double` type of elements to `num` type.
- Override `==` operator for `MatrixBase`, `VectorBase` and `Complex` classes.

## 0.0.9

- Override `*`, `/`, `+` and `-` operators of `VectorBase` class.
- Removes `add()` and `subtract()` methods of `VectorBase` class.
- Override `*`, `/`, `+` and `-` operators of `MatrixBase` class.
- Removes `add()` and `subtract()` methods of `MatrixBase` class.

## 0.0.8

- Unit `number_theory` and `linear_algebra` into `discrete_mathematics`.
- Add `Probability theory` subsection with `NumbersGenerator` class.
- Correct title in `LICENSE`.

## 0.0.7

- Add `Complex analysis`, `General` and `Number theory` sections.
- Implement `QuadraticEquation` and `CubicEquation` classes of `General` section.
- Implement `CompositeNumber` of `Number theory` section.
- Add `eliminate()` method to `SquareMatrix` class.

## 0.0.6

- Add `rowAsVector()`, `columnAsVector()` methods to `MatrixBase` class.
- Override `multiplyByVector()` and `inverse()` methods in `DiagonalMatrix` class.
- Add `isSymmetric()` and `isOrthogonal()` methods to `SquareMatrix` class.
- Add `hadamardProduct()`, `transform()`, `isUnit()`, `isOrthogonalTo()`, `isOrthonormalWith()`
  methods to `VectorBase` class.

## 0.0.5

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
