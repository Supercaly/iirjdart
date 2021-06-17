import 'package:complex/complex.dart';
import 'package:iirjdart/src/pole_zero_pair.dart';

/// PoleZeroPair with gain factor
class BiquadPoleState extends PoleZeroPair {
  double gain = 0.0;

  factory BiquadPoleState.single(Complex p, Complex z) =>
      BiquadPoleState(p, z, Complex(0.0, 0.0), Complex(0.0, 0.0));

  BiquadPoleState(Complex p1, Complex z1, Complex p2, Complex z2)
      : super(p1, z1, p2, z2);
}
