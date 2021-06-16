import 'dart:math' as math;

import 'package:complex/complex.dart';
import 'package:iirjdart/src/complex_pair.dart';
import 'package:iirjdart/src/layout_base.dart';
import 'package:iirjdart/src/math_supplement.dart';
import 'package:iirjdart/src/pole_zero_pair.dart';

/// Transforms from an analogue lowpass filter to a digital bandstop filter
class BandStopTransform {
  late double _wc;
  late double _wc2;
  late double _a;
  late double _b;
  late double _a2;
  late double _b2;

  BandStopTransform(
      double fc, double fw, LayoutBase digital, LayoutBase analog) {
    digital.reset();

    double ww = 2 * math.pi * fw;

    _wc2 = 2 * math.pi * fc - (ww / 2);
    _wc = _wc2 + ww;

    // this is crap
    if (_wc2 < 1e-8) _wc2 = 1e-8;
    if (_wc > math.pi - 1e-8) _wc = math.pi - 1e-8;

    _a = math.cos((_wc + _wc2) * .5) / math.cos((_wc - _wc2) * .5);
    _b = math.tan((_wc - _wc2) * .5);
    _a2 = _a * _a;
    _b2 = _b * _b;

    int numPoles = analog.getNumPoles();
    int pairs = numPoles ~/ 2;
    for (int i = 0; i < pairs; i++) {
      PoleZeroPair pair = analog.getPair(i);
      ComplexPair p = transform(pair.poles.first);
      ComplexPair z = transform(pair.zeros.first);
      digital.addPoleZeroConjugatePairs(p.first, z.first);
      digital.addPoleZeroConjugatePairs(p.second, z.second);
    }

    if ((numPoles & 1) == 1) {
      ComplexPair poles = transform(analog.getPair(pairs).poles.first);
      ComplexPair zeros = transform(analog.getPair(pairs).zeros.first);

      digital.addPairs(poles, zeros);
    }

    if (fc < 0.25)
      digital.setNormal(math.pi, analog.normalGain);
    else
      digital.setNormal(0, analog.normalGain);
  }

  ComplexPair transform(Complex c) {
    if (c.isInfinite)
      c = new Complex(-1);
    else
      c = (Complex(1) + c) / (Complex(1) - c); // bilinear

    Complex u = new Complex(0);
    u = MathSupplement.addmul(u, 4 * (_b2 + _a2 - 1), c);
    u += (8 * (_b2 - _a2 + 1));
    u *= c;
    u += (4 * (_a2 + _b2 - 1));
    u = u.sqrt();

    Complex v = u * (-0.5);
    v += _a;
    v = MathSupplement.addmul(v, -_a, c);

    u *= 0.5;
    u += _a;
    u = MathSupplement.addmul(u, -_a, c);

    Complex d = new Complex(_b + 1);
    d = MathSupplement.addmul(d, _b - 1, c);

    return new ComplexPair(u / d, v / d);
  }
}
