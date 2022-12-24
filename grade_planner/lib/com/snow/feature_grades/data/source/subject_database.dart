import 'dart:io';

import 'package:f_logs/model/flog/flog.dart';

class SubjectDatabase {
  final File _subjectDataFile;

  SubjectDatabase(this._subjectDataFile);

  static const String EMPTY_FILE = """
  [
  
  ]
  """;

  Future<String> getRawGradeData() async {
    try {
      String data = await _subjectDataFile.readAsString();

      if (data.isEmpty) {
        data = EMPTY_FILE;
        replaceRawData(content: EMPTY_FILE);
      }

      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> replaceRawData({required String content}) async {
    FLog.info(text: """
    Will try to write to the File.
    Content to write:
    $content
    Size before:
    ${_subjectDataFile.lengthSync()} bytes
    Content before:
    ${getRawGradeData()}
    """);
    if (await _subjectDataFile.exists()) {
      try {
        await _subjectDataFile.writeAsString(content);
        FLog.info(text: """
        Wrote the content to the File.
        Size now:
        ${_subjectDataFile.lengthSync()} bytes
        Content now:
        ${getRawGradeData()}
        """);
      } catch (e) {
        FLog.error(text: """
        An error occured while trying to write to the file:
        ${e.toString()}
        """);
        rethrow;
      }
    } else {
      FLog.error(text: "The File was not found.");
    }
  }
}
