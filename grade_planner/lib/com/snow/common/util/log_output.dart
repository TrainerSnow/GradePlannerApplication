import 'dart:io';

import 'package:logger/logger.dart';

class FileOutput extends LogOutput {
  final File file;

  FileOutput(this.file);

  @override
  void output(OutputEvent event) {
    if (event.level != Level.debug && event.level != Level.verbose) {
      _write(event.lines);
    }
  }

  void _write(List<String> ss) async {
    for (String s in ss) {
      await file.writeAsString(s);
    }
  }
}
