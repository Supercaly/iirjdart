import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';
import 'package:iirjdart/butterworth.dart';

void main() {
  final String prefix = "test/test_results/detector/";

  test("detect ECG's heartbeat", () async {
    Butterworth butterworth = new Butterworth();
    // this fakes an R peak so we have a matched filter!
    butterworth.bandPass(2, 250, 20, 15);

    final file = File(prefix + "det.txt");
    await file.create(recursive: true);
    final sink = file.openWrite();

    final fileHr = File(prefix + "hr.txt");
    await fileHr.create(recursive: true);
    final sinkHr = fileHr.openWrite();

    final ecgFile = File("test/test_resources/ecg.dat");
    final ecgLines =
        ecgFile.openRead().transform(Utf8Decoder()).transform(LineSplitter());

    double max = 0;
    double t1 = 0, t2 = 0;
    int notDet = 0;
    double time = 0;
    int ignore = 100;
    int sampleno = 0;

    await for (String line in ecgLines) {
      // let's do an impulse response
      double v = 0;
      time = time + 1.0 / 125.0;
      v = double.parse(line);
      v = butterworth.filter(v);
      v = v * v;
      sink.writeln("$v");
      if (ignore > 0) {
        ignore--;
      } else {
        if (v > max) {
          max = v;
        }
      }
      if (notDet > 0) {
        notDet--;
      } else {
        if (v > 0.5 * max) {
          t1 = time;
          notDet = 50;
          int r = ((t1 - t2) * 60).round().toInt();
          if (r > 30) {
            sinkHr.writeln("$sampleno $r");
            expect((r > 60) && (r < 160), isTrue);
          }
          t2 = t1;
        }
      }
      sampleno++;
    }

    await sink.flush();
    await sink.close();
    await sinkHr.flush();
    await sinkHr.close();
  });
}
