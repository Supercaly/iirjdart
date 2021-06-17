import 'package:complex/complex.dart';
import 'package:iirjdart/src/complex_pair.dart';
import 'package:iirjdart/src/pole_zero_pair.dart';

/// Digital/analogue filter coefficient storage space organising the
/// storage as PoleZeroPairs so that we have as always a 2nd order filter
class LayoutBase {
  late int _numPoles;
  late List<PoleZeroPair?> _pair;
  late double _normalW;
  late double _normalGain;

  LayoutBase.fromPairs(List<PoleZeroPair?> pairs) {
    _numPoles = pairs.length * 2;
    _pair = pairs;
  }

  LayoutBase(int numPoles) {
    _numPoles = 0;
    if ((numPoles % 2) == 1) {
      _pair = List.filled(numPoles ~/ 2 + 1, null);
    } else {
      _pair = List.filled(numPoles ~/ 2, null);
    }
  }

  void reset() {
    _numPoles = 0;
  }

  int getNumPoles() {
    return _numPoles;
  }

  void add(Complex pole, Complex zero) {
    _pair[_numPoles ~/ 2] = PoleZeroPair.single(pole, zero);
    ++_numPoles;
  }

  void addPoleZeroConjugatePairs(Complex pole, Complex zero) {
    if (pole == null) print("LayoutBase addConj() pole == null");
    if (zero == null) print("LayoutBase addConj() zero == null");
    if (_pair == null) print("LayoutBase addConj() m_pair == null");
    _pair[_numPoles ~/ 2] =
        PoleZeroPair(pole, zero, pole.conjugate(), zero.conjugate());
    _numPoles += 2;
  }

  void addPairs(ComplexPair poles, ComplexPair zeros) {
    _pair[_numPoles ~/ 2] =
        new PoleZeroPair(poles.first, zeros.first, poles.second, zeros.second);
    _numPoles += 2;
  }

  PoleZeroPair getPair(int pairIndex) => _pair[pairIndex]!;

  double get normalW => _normalW;

  double get normalGain => _normalGain;

  void setNormal(double w, double g) {
    _normalW = w;
    _normalGain = g;
  }
}
