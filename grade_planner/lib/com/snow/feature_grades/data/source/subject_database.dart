import 'dart:io';

import 'package:grade_planner/com/snow/di/injecting.dart';

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
    try {
      _subjectDataFile.writeAsString(content);
    } catch (e) {
      rethrow;
    }
  }
}
