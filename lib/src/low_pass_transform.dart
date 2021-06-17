import 'dart:math' as math;

import 'package:complex/complex.dart';
import 'package:iirjdart/src/layout_base.dart';
import 'package:iirjdart/src/pole_zero_pair.dart';

/// Transforms from an analogue lowpass filter to a digital lowpass filter
class LowPassTransform {
  late double f;

  Complex transform(Complex c) {
    if (c.isInfinite) return new Complex(-1, 0);

    // frequency transform
    c *= f;

    Complex one = new Complex(1, 0);

    // bilinear low pass transform
    return (one + c) / (one - c);
  }

  LowPassTransform(double fc, LayoutBase digital, LayoutBase analog) {
    digital.reset();

    // prewarp
    f = math.tan(math.pi * fc);

    int numPoles = analog.getNumPoles();
    int pairs = numPoles ~/ 2;
    for (int i = 0; i < pairs; ++i) {
      PoleZeroPair pair = analog.getPair(i);
      digital.addPoleZeroConjugatePairs(
          transform(pair.poles.first), transform(pair.zeros.first));
    }

    if ((numPoles & 1) == 1) {
      PoleZeroPair pair = analog.getPair(pairs);
      digital.add(transform(pair.poles.first), transform(pair.zeros.first));
    }

    digital.setNormal(analog.normalW, analog.normalGain);
  }
}
