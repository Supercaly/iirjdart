# iirjdart

An IIR filter library written in Dart.
Highpass, lowpass, bandpass and bandstop as Butterworth, Bessel and Chebyshev Type I/II.

This library is a porting in Dart of the [famous iirj library by berndporr](https://github.com/berndporr/iirj).

![alt tag](filtertest.png)

## Usage

To use this package add `iirjdart` as a [dependency in your pubspec.yaml file.](https://flutter.dev/docs/development/packages-and-plugins/using-packages)

Import the library.

`import 'package:iirjdart/butterworth.dart';`

Then create the filter that you want.

`Butterworth butterworth = new Butterworth();`

And initialize it with:
1. Bandstop

   `butterworth.bandStop(order,Samplingfreq,Center freq,Width in frequ);`

2. Bandpass

   `butterworth.bandPass(order,Samplingfreq,Center freq,Width in frequ);`

3. Lowpass

   `butterworth.lowPass(order,Samplingfreq,Cutoff frequ);`

4. Highpass

   `butterworth.highPass(order,Samplingfreq,Cutoff frequ);`

### Filtering
The filtering is done sample by sample for realtime processing:

```
v = butterworth.filter(v)
```

## Coding examples
See the `test/*_test.dart` files for complete examples
for all filter types.

## ToDo

- [ ] Add Bessel filter