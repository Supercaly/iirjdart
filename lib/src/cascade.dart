import 'dart:math' as math;

import 'package:complex/complex.dart';
import 'package:iirjdart/src/biquad.dart';
import 'package:iirjdart/src/direct_form.dart';
import 'package:iirjdart/direct_form_1.dart';
import 'package:iirjdart/direct_form_2.dart';
import 'package:iirjdart/src/layout_base.dart';
import 'package:iirjdart/src/math_supplement.dart';
import 'package:iirjdart/src/pole_zero_pair.dart';

/// The mother of all filters. It contains the coefficients of all
/// filter stages as a sequence of 2nd order filters and the states
/// of the 2nd order filters which also imply if it's direct form I or II
class Cascade {
  // coefficients
  List<Biquad> _biquads;

  // the states of the filters
  List<DirectFormAbstract> _states;

  // number of biquads in the system
  int _numBiquads;

  int _numPoles;

  int getNumBiquads() {
    return _numBiquads;
  }

  Biquad getBiquad(int index) {
    return _biquads[index];
  }

  Cascade()
      : _numBiquads = 0,
        _numPoles = 0,
        _biquads = [],
        _states = [];

  void reset() {
    for (int i = 0; i < _numBiquads; i++) _states[i].reset();
  }

  double filter(double _in) {
    double out = _in;
    for (int i = 0; i < _numBiquads; i++) {
      if (_states[i] != null) {
        out = _states[i].process1(out, _biquads[i]);
      }
    }
    return out;
  }

  Complex response(double normalizedFrequency) {
    double w = 2 * math.pi * normalizedFrequency;
    Complex czn1 = Complex.polar(1.0, -w);
    Complex czn2 = Complex.polar(1.0, -2 * w);
    Complex ch = new Complex(1);
    Complex cbot = new Complex(1);

    for (int i = 0; i < _numBiquads; i++) {
      Biquad stage = _biquads[i];
      Complex cb = new Complex(1);
      Complex ct = new Complex(stage.getB0() / stage.getA0());
      ct = MathSupplement.addmul(ct, stage.getB1() / stage.getA0(), czn1);
      ct = MathSupplement.addmul(ct, stage.getB2() / stage.getA0(), czn2);
      cb = MathSupplement.addmul(cb, stage.getA1() / stage.getA0(), czn1);
      cb = MathSupplement.addmul(cb, stage.getA2() / stage.getA0(), czn2);
      ch *= ct;
      cbot *= cb;
    }

    return ch / cbot;
  }

  void applyScale(double scale) {
    // For higher order filters it might be helpful
    // to spread this factor between all the stages.
    if (_biquads.length > 0) {
      _biquads[0].applyScale(scale);
    }
  }

  void setLayout(LayoutBase proto, int filterTypes) {
    _numPoles = proto.getNumPoles();
    _numBiquads = (_numPoles + 1) ~/ 2;

    switch (filterTypes) {
      case DirectFormAbstract.direct_form_I:
        _states = List.generate(_numBiquads, (_) => DirectFormI());
        break;
      case DirectFormAbstract.direct_form_II:
      default:
        _states = List.generate(_numBiquads, (_) => DirectFormII());
        break;
    }
    _biquads = List.generate(_numBiquads, (i) {
      PoleZeroPair p = proto.getPair(i);
      final biquad = Biquad();
      biquad.setPoleZeroPair(p);
      return biquad;
    });

    applyScale(
        proto.normalGain / ((response(proto.normalW / (2 * math.pi)))).abs());
  }
}
