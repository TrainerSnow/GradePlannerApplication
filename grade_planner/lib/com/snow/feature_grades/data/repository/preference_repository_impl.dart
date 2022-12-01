import 'dart:convert';

import 'package:grade_planner/com/snow/feature_grades/data/source/preferences_database.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/model/userpreferences.dart';
import 'package:grade_planner/com/snow/feature_grades/domain/repository/preferences_repository.dart';

class PreferencesRepositoryImpl extends PreferencesRepository {
  PreferencesDatabase database;

  PreferencesRepositoryImpl(this.database);

  @override
  Future<UserPreferences> getPreferences() async {
    var content = await database.getRawGradeData();

    dynamic json = jsonDecode(content);
    return UserPreferences.fromJson(json);
  }

  @override
  void updatePreferences(UserPreferences preferences) {
    database.replaceRawData(content: jsonEncode(preferences));
  }
}
