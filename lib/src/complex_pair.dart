import 'package:complex/complex.dart';

/// A complex pair
class ComplexPair {
  late Complex first;
  late Complex second;

  ComplexPair(Complex c1, [Complex? c2]) {
    first = c1;
    second = c2 ?? Complex(0.0, 0.0);
  }

  bool get isConjugate => second == first.conjugate();

  bool get isReal => first.imaginary == 0 && second.imaginary == 0;

  /// Returns true if this is either a conjugate pair,
  /// or a pair of reals where neither is zero.
  bool get isMatchedPair {
    if (first.imaginary != 0)
      return isConjugate;
    else
      return second.imaginary == 0 && second.real != 0 && first.real != 0;
  }

  bool get isNan => first.isNaN || second.isNaN;
}
