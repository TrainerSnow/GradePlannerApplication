import 'dart:io';

class PreferencesDatabase {
  final File _preferenceDataFile;

  PreferencesDatabase(this._preferenceDataFile);

  static const String EMPTY_FILE = """
  {
    "currentYear":"",
    "orderMode": 1
  }
  """;

  Future<String> getRawGradeData() async {
    try {
      String data = await _preferenceDataFile.readAsString();

      if (data.isEmpty) {
        data = EMPTY_FILE;
        replaceRawData(content: EMPTY_FILE);
      }

      return data;
    } catch (e) {
      rethrow;
    }
  }

  void replaceRawData({required String content}) {
    try {
      _preferenceDataFile.writeAsString(content);
    } catch (e) {
      rethrow;
    }
  }
}
