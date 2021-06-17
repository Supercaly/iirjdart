import 'package:iirjdart/src/biquad.dart';
import 'package:iirjdart/src/direct_form.dart';

/// Implementation of a Direct Form II filter with its states. The coefficients
/// are supplied from the outside.
class DirectFormII extends DirectFormAbstract {
  late double _v1; // v[-1]
  late double _v2; // v[-2]

  DirectFormII() {
    reset();
  }

  @override
  void reset() {
    _v1 = 0;
    _v2 = 0;
  }

  @override
  double process1(double _in, Biquad s) {
    if (s != null) {
      double w = _in - s.a1 * _v1 - s.a2 * _v2;
      double out = s.b0 * w + s.b1 * _v1 + s.b2 * _v2;

      _v2 = _v1;
      _v1 = w;

      return out;
    } else {
      return _in;
    }
  }
}
