import 'package:complex/complex.dart';
import 'package:iirjdart/src/complex_pair.dart';

class PoleZeroPair {
  late ComplexPair poles;
  late ComplexPair zeros;

  // single pole/zero
  factory PoleZeroPair.single(Complex p, Complex z) =>
      PoleZeroPair(p, z, Complex(0, 0), Complex(0, 0));

  // pole/zero pair
  PoleZeroPair(Complex p1, Complex z1, Complex p2, Complex z2) {
    poles = ComplexPair(p1, p2);
    zeros = ComplexPair(z1, z2);
  }

  bool get isSinglePole =>
      poles.second == Complex(0, 0) && zeros.second == Complex(0, 0);

  bool get isNan => poles.isNan || zeros.isNan;
}
