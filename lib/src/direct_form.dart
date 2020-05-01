
import 'package:iirjdart/src/biquad.dart';

/// Abstract form of the a filter which can have different state variables
///
/// Direct form I or II is derived from it
abstract class DirectFormAbstract {
  static const int direct_form_I = 0;
  static const int direct_form_II = 1;

  DirectFormAbstract() {
    reset();
  }

  void reset();

  double process1(double _in, Biquad s);
}
