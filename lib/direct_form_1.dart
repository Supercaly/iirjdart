import 'package:iirjdart/src/biquad.dart';
import 'package:iirjdart/src/direct_form.dart';

/// Implementation of a Direct Form I filter with its states. The coefficients
/// are supplied from the outside.
class DirectFormI extends DirectFormAbstract {
  late double _x2; // x[n-2]
  late double _y2; // y[n-2]
  late double _x1; // x[n-1]
  late double _y1; // y[n-1]

  DirectFormI() {
    reset();
  }

  @override
  void reset() {
    _x1 = 0;
    _x2 = 0;
    _y1 = 0;
    _y2 = 0;
  }

  @override
  double process1(double _in, Biquad s) {
    double out = s.b0 * _in + s.b1 * _x1 + s.b2 * _x2 - s.a1 * _y1 - s.a2 * _y2;
    _x2 = _x1;
    _y2 = _y1;
    _x1 = _in;
    _y1 = out;

    return out;
  }
}
